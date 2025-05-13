class Document < ApplicationRecord
    #Add validations
    #ensures content can't be empty
    #ensures version must exist and be a positive number
    validates :content, presence: true
    validates :version, presence: true, numericality: { greater_than: 0}

    #Create the method to apply operations

    def apply_operation(operation)
        #increment version
        self.version += 1

        # Apply operation based on typ
        case operation.type
        when :insert
            insert_text(operation)
        when :delete
            delete_text(operation)
        end

        save!
    end

    private 

    # This handles text insertion:

    # Breaks content into characters
    # Inserts new text at specified position
    # Joins it back into a string

    def insert_text(operation)
        content_array = content.chars
        content_array.insert(operation.position, operation.text)
        self.content = content_array.join
    end

    # This handles text deletion:

    # Breaks content into characters
    # Removes specified characters
    # Joins it back into a string

    def delete_text(operation)
        content_array = content.chars
        content_array.slice!(operation.position, operation.length)
        self.content = content_array.join
    end
end