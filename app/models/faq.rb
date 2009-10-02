class Faq < ActiveRecord::Base
  belongs_to :user
  #acts_as_ferret

  QUESTIONS = %w(short_cv selected_papers schools companies
                 work_experience job_advertisement)

  QUESTIONS_1 = %w(short_cv selected_papers schools)
  QUESTIONS_2 = %w(companies work_experience job_advertisement)


  # A constant for everything except the bio
  FAVORITES = QUESTIONS - %w(short_cv)
  TEXT_ROWS = 10
  TEXT_COLS = 30
  
  def initialize
    super
    QUESTIONS.each do |question|
      self[question] = ""
    end
  end
end
