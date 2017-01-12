Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # home
  root 'home#index'
  get 'home/secured'

  get 'data_source/borrowers_list'


  resources :borrowers do
    member do
      get 'destroy_by_popup'
    end
  end

  resources :loans do
  end

  resources :loan_templates do
  end

end

