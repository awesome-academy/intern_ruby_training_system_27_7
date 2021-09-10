require "sidekiq/web"

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    mount Sidekiq::Web => "/sidekiq"

    root "static_pages#home"
    devise_for :users, controllers: {sessions: "sessions"}
    resources :trainees, except: :show
    resources :users, only: %i(show edit update)
    resources :courses do
      resources :user_courses, only: %i(create destroy), shallow: true
      resources :course_subjects, only: %i(create destroy), shallow: true
      resources :course_subjects, only: :show
    end
    resources :course_subjects do
      resources :course_subject_tasks, only: :create
      resources :course_subject_tasks, only: :destroy, shallow: true
    end
    resources :user_courses
    resources :user_course_subjects, only: :update
    resources :user_reports
  end
end
