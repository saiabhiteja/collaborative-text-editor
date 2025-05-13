Rails.application.routes.draw do
  # Root route points to documents index
  root 'documents#index'
  
  # RESTful routes for documents
  resources :documents
  
  # Mount Action Cable server
  mount ActionCable.server => '/cable'
  
  # Keep the health check route
  get "up" => "rails/health#show", as: :rails_health_check
end