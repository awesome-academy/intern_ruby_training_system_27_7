Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :courses do
      resources :user_courses, only: %i(create destroy), shallow: true
      resources :course_subjects, only: %i(create destroy), shallow: true
    end
    resources :user_courses
    resources :user_reports
  end
end
