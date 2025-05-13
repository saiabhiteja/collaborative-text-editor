class DocumentChannel < ApplicationCable::Channel
  def subscribed
    @document = Document.find(params[:id])
    stream_for @document
  end

  def receive(data)
    operation = build_operation(data)
    
    # Apply operation to document
    @document.apply_operation(operation)
    
    # Broadcast operation to other clients
    DocumentChannel.broadcast_to(
      @document,
      { 
        operation: operation,
        version: @document.version,
        client_id: data["client_id"]
      }
    )
  end

  private

  def build_operation(data)
    case data["type"]
    when "insert"
      InsertOperation.new(
        text: data["text"],
        position: data["position"],
        version: data["version"]
      )
    when "delete"
      DeleteOperation.new(
        position: data["position"],
        length: data["length"],
        version: data["version"]
      )
    end
  end
end
