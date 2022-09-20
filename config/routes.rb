Rails.application.routes.draw do


  get 'about' => 'pages#about'

  get 'faq' => 'pages#faq'

  get 'upload_quiz' => 'pages#upload_quiz'

  post 'sync_quiz' => 'quizzes#sync_quiz'

  get 'question_bank' => 'quizzes#question_bank'

  get 'login', to: 'sessions#new'

  post 'login', to: 'sessions#create'

  delete 'logout', to: 'sessions#destroy'
  
  resources:quizzes

  resources:questions

  resources:options

  resources:categories

  resources:submissions

  get 'signup', to: 'users#new'

  resources:users, except:[:new]
  
  get 'question/edit' => 'quizzes#editQuestion'

  get 'option/edit' => 'quizzes#editOption'

  get 'editPassword' => 'users#editPassword'

  post 'editPassword' => 'users#updatePassword'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'
end
