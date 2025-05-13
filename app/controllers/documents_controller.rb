class DocumentsController < ApplicationController
    def index
      @documents = Document.all
    #   render json: @documents
    end
  
    def show
      @document = Document.find(params[:id])
    #   render json: {
    #     content: @document.content,
    #     version: @document.version
    #   }
    end
  
    def create
      @document = Document.create!(content: "New Document", version: 1)
    #   render json: @document
      redirect_to @document
    end
  
    def update
      @document = Document.find(params[:id])
      if @document.update(document_params)
        render json: @document
      else
        render json: @document.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def document_params
      params.require(:document).permit(:content)
    end
  end