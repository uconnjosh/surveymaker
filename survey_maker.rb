require 'active_record'
require './lib/survey'
require './lib/question'
require './lib/answer_option'
require './lib/response'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)


def menu
  system("clear")
  puts "~~~~~~~~Welcome to the Survey Monkey!~~~~~~~~\n\n"
  puts "What are you? Just a survey-TAKER, or a surver-MAKER????\n\n"
  puts "Press 'A' for survey taker, and 'B' for survey maker."
  puts "Press 'X' to leave this wonderful program :("
  menu_answer = gets.chomp.upcase
  case menu_answer
    when 'A'
      survey_taker
    when 'B'
      survey_maker
    when 'X'
      puts "Bye Bye Bye Bye Bye, now :("
  end
end

def survey_taker
  puts "Here are all of the available surveys:"
  Survey.all.each do |this_survey|
    puts "#{this_survey.id}.....#{this_survey.name}\n"
  end
  puts "Enter the number of the survey that you would like to take:"
  survey_to_select = gets.chomp.to_i
  # current_survey = Survey.find(survey_to_select)
  questions = Question.where({:survey_id => survey_to_select})
  questions.each do |q|
    puts q.name
    responses = AnswerOption.where({:question_id => q.id})
    responses.each_with_index do |r, index|
      puts "#{index+1}....#{r.name}"
    end
    puts "Please enter the number of your choice:"
    picker = gets.chomp.to_i
    picker = picker -1
    chosen_response = responses[picker]
    chosen_response = chosen_response.id
    Response.create({:answer_option_id => chosen_response})
    puts "Response noted!"
  end
  menu
end

def survey_maker
  # system("clear")
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
  puts "Got it!!! Added '#{survey.name}'.\n\n"
  input = " "
  until input == 'N' do
    puts "What questions would you like to add to your survey? Enter your question below:\n"
    question_name = gets.chomp
    new_question = Question.create({:name => question_name, :survey_id => survey.id})

    puts "\nGood question! What answer options would you like to add?"
    adding_responses = " "
    until adding_responses == "N" do
      puts "Enter an answer option below:"
      response_name = gets.chomp.capitalize
      new_response = AnswerOption.create({:name => response_name, :question_id => new_question.id})
      puts "\nGot it! Added '#{new_response.name}' as an answer option!"
      puts "Would you like to add another answer option to the question '#{new_question.name}'?"
      puts "Press 'Y' for yes and 'N' for no."
      adding_responses = gets.chomp.upcase
    end

    puts "\nAll set! Those responses have been added. Would you like to add another question to #{title}?"
    puts "Press 'Y' for yes and 'N' for no.\n"
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
# begin
  selected_survey = Survey.find(input)
  selected_survey.questions.each do |this_question|
    puts "#{this_question.id}.....#{this_question.name}"
    possible_responses = AnswerOption.where({:question_id => this_question.id})
    possible_responses.each_with_index do |r, index|
      puts "#{index+1}....#{r.name}"
      total_responses = possible_responses.length.to_f
      numerator = Response.where({:answer_option_id => r.id})
      numerator = numerator.length.to_f
      percentage = (numerator / total_responses)
      percentage = percentage * 100
      percentage = percentage.round(2)
      puts "This has been chosen #{percentage}% of the time"
    end
  end
# rescue
#   puts "Looks like that survery isn't created yet, please pick another one"
#   view_surveys
# end
  survey_maker
end
menu
