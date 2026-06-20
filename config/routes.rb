require "sidekiq/web"
require "sidekiq-failures"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#index"
  get "*path", to: "pages#index", constraints: ->(req) { req.format.html? }
end
