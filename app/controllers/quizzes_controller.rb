require 'spreadsheet'
class QuizzesController < ApplicationController

  before_action :require_user, except: [:index]
  before_action :require_admin, except: [:index, :show]

  def index
    if logged_in? and current_user.admin?
      @quizzes = Quiz.paginate(page: params[:page], per_page: 6)
      @submissions = Submission.all
    elsif logged_in?
      @quizzes = Quiz.where(id: QuestionsQuiz.select("quiz_id").group(:quiz_id).having("count(id)>1")).paginate(page: params[:page], per_page: 6)
      @submissions = current_user.submissions
      @submitted_quizzes = Quiz.joins(:submissions).where(id: @submissions.pluck(:quiz_id))
    else
      @quizzes = Quiz.where(id: QuestionsQuiz.select("quiz_id").group(:quiz_id).having("count(id)>1")).paginate(page: params[:page], per_page: 6) #Only send quizzes with more than 1 question
    end        
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      flash[:success] = "Quiz was successfully created"
      redirect_to quiz_path(@quiz)
    else
      render 'new'
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update
    @quiz = Quiz.find(params[:id])

    if @quiz.update(quiz_params)
      flash[:success] = "Quiz was successfully updated"
      redirect_to quiz_path(@quiz)
    else
      render 'edit'
    end

  end

  def show
    @quiz = Quiz.find(params[:id])
    @questions = @quiz.questions #Questions of the quiz
    @question_all = @questions.paginate(page: params[:page], per_page: 5) #questions paginated
    @total_score = @questions.sum(:score) #Total score of all the questions in the quiz
    @option = Option.new
    @option_all = Option.where(question_id: @questions) #All options of the quiz
    quest_count=0 #Count of all the valid questions in the quiz
    @questions.each do |each_question| 
      found = false #Presence of answer
      count=0 #Number of options
        @option_all.each do |each_option| 
        if each_option.question_id == each_question.id 
          count +=1 
          if each_option.is_answer == true 
            found = true 
          end 
        end 
      end 
       if found==true && count>=2 #Increment valid question count if number of options is more than 1 and has an answer
         quest_count+=1 
       end 
    end 
    if !current_user.admin? && (@questions.length()<2 || quest_count < 2)
      redirect_to quizzes_path
    end
    @submission = Submission.new 
    @submission.quest_submissions.build #Nested form for quest_submissions

    @question = Question.new
    if params.has_key?(:question_messages) #Check if error messages are passed and display them
      @question_messages = params[:question_messages] 
    else
      @question_messages = ""
    end
    if params.has_key?(:option_messages)
      @option_messages = params[:option_messages] 
    else
      @option_messages = ""
    end  
  end

  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy
    flash[:danger] = "Quiz was successfully deleted"
    redirect_to quizzes_path
  end

  def editQuestion
    @each_question = Question.find(params[:each_question].to_i)
    if params.has_key?(:question_messages) #Check if error messages are passed and display them
      @question_messages = params[:question_messages] 
    else
      @question_messages = ""
    end
  end

  def editOption
    @each_option = Option.find(params[:each_option].to_i) 
    @each_question = Question.find(@each_option.question_id) #Question of that option
    if params.has_key?(:option_messages) #Check if error messages are passed and display them
      @option_messages = params[:option_messages] 
    else
      @option_messages = ""
    end
  end

  def sync_quiz
    Spreadsheet.run
    flash[:success] = "Quiz synced successfully"
    redirect_to upload_quiz_path
  end

  def question_bank
    @questions = Question.all #Questions of the quiz
    @question_all = @questions.paginate(page: params[:page], per_page: 10) #questions paginated
    @total_score = @questions.sum(:score) #Total score of all the questions in the quiz
    @option = Option.new
    @option_all = Option.where(question_id: @questions) #All options of the quiz

    @question = Question.new
    if params.has_key?(:question_messages) #Check if error messages are passed and display them
      @question_messages = params[:question_messages] 
    else
      @question_messages = ""
    end
    if params.has_key?(:option_messages)
      @option_messages = params[:option_messages] 
    else
      @option_messages = ""
    end 
  end

  private

  def quiz_params

    params.require(:quiz).permit(:name, category_ids: [])

  end
end
