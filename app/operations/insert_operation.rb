class InsertOperation < BaseOperation
    attr_reader :text
    
    def initialize(text:, position:, version:)
      super(type: :insert, position: position, version: version)
      @text = text
    end
    
    def transform(other)
      case other.type
      when :insert
        # If our position is before other's position, or we're at same position and win tiebreaker
        if position < other.position || 
           (position == other.position && !other.win_tiebreaker)
          self
        else
          # Move our position over by the length of the other insert
          InsertOperation.new(
            text: text,
            position: position + other.text.length,
            version: version
          )
        end
      when :delete
        # If our position is before or at delete position, no change needed
        if position <= other.position
          self
        else
          # Move our position back by the length of the delete
          InsertOperation.new(
            text: text,
            position: position - other.length,
            version: version
          )
        end
      end
    end
  end