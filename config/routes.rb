CommunIt2::Application.routes.draw do
  root to: "dashboard#main"
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout 
end
