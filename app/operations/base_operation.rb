class BaseOperation
    attr_reader :type, :position, :version

    def intialize(type:, position:, version:)
        @type = type
        @position = position
        @version = version
    end

    def transform(other_operation)
        raise NotImplementedError
    end
end