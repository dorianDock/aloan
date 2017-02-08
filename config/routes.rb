Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # home
  root 'home#index'
  get 'home/secured'

  # data_source
  get 'data_source/borrowers_list'
  get 'data_source/loan_templates_list'

  # statistics
  get 'statistics/index'

  # borrowers
  resources :borrowers do
    member do
      get 'destroy_by_popup'
    end
  end

  # loans
  resources :loans do
  end

  # loan_templates
  get 'loan_templates/json_for_template'

  resources :loan_templates do
    member do
      get 'destroy_by_popup'
      get 'prerequisite_for_template'
    end

  end

end

