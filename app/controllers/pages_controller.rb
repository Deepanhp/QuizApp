class PagesController < ApplicationController

  before_action :require_admin, only: [:upload_quiz]

  def index
  	redirect_to quizzes_path if logged_in?
  end

  def about
  end

  def faq
  end

  def upload_quiz
  end
end
