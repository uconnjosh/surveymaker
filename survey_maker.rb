require 'active_record'
require './lib/survey'
require './lib/question'
require './lib/answer_option'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)


def welcome
  puts "~~~~~~~~Welcome to the Survey Taker!~~~~~~~~\n\n"
  menu
end

def menu
  puts "What are you? Just a survey-TAKER, or a surver-MAKER????"
  puts "Press 'A' for survey taker, and 'B' for survey maker."
  puts "Press 'X' to leave this wonderful program :("
  menu_answer = gets.chomp.upcase
  case menu_answer
    when 'A'
      survey_taker
    when 'B'
      survey_maker
    when 'X'
      puts "Bye Bye Bye Bye Bye, now :(........"
  end
end

def survey_taker
  puts "Which survey do you want to take?"
  menu
  end

def survey_maker
  puts "Press 'N' to create a new survey."
  puts "Press 'V' to view your surveys."
  puts "Press 'M' to return to the main menu."
  maker_response = gets.chomp.upcase
  case maker_response
  when 'N'
    new_survey
  when 'V'
    view_surveys
  when 'M'
    menu
  end
end

def new_survey
  puts "What do you want to call your survey?:"
  title = gets.chomp.titleize
  survey = Survey.create({:name => title})
  puts "Got it!!! Added #{survey.name}.\n\n"
  input = " "
  until input == 'N' do
    puts "What questions would you like to add to your survey? Enter your question below:\n"
    question_name = gets.chomp
    new_question = Question.create({:name => question_name, :survey_id => survey.id})

    puts "Good question! What answer options would you like to add?"
    adding_responses = " "
    until adding_responses == "N" do
      puts "Enter the name of the response:"
      response_name = gets.chomp.capitalize
      new_response = AnswerOption.create({:name => response_name, :question_id => new_question.id})
      puts "Got it! Added #{new_response.name}!"
      puts "Would you like to add another response to #{new_question.name}?"
      puts "Press N for no"
      adding_responses = gets.chomp.upcase
    end

    puts "All set! Those responses have been added. Would you like to add another question to #{title}?"
    input = gets.chomp.upcase
end
  survey_maker
end

def view_surveys
  puts "Here is a list of all your surveys:"
  Survey.all.each do |this_survey|
    puts "#{this_survey.id}.....#{this_survey.name}\n"
  end
  puts "Do you want to edit a survey? Pick one!"
  input = gets.chomp.to_i
  selected_survey = Survey.find(input)
  selected_survey.questions.each do |this_question|
    puts "#{this_question.id}.....#{this_question.name}"
  end
  survey_maker
end
welcome



