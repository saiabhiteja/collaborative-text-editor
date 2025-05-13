class DeleteOperation < BaseOperation
    attr_reader :length
    
    def initialize(position:, length:, version:)
      super(type: :delete, position: position, version: version)
      @length = length
    end
    
    def transform(other)
      case other.type
      when :insert
        # If deleting before insert point, no change needed
        if position < other.position
          self
        else
          # Move our position over by the length of the insert
          DeleteOperation.new(
            position: position + other.text.length,
            length: length,
            version: version
          )
        end
      when :delete
        if position + length <= other.position
          # Our deletion is entirely before other deletion
          self
        elsif position >= other.position + other.length
          # Our deletion is entirely after other deletion
          DeleteOperation.new(
            position: position - other.length,
            length: length,
            version: version
          )
        else
          # Deletions overlap - handle the overlap
          new_position = [position, other.position].min
          new_length = length - (other.position + other.length - position)
          DeleteOperation.new(
            position: new_position,
            length: new_length,
            version: version
          )
        end
      end
    end
  end