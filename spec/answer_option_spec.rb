require 'spec_helper'

describe AnswerOption do
  it {should belong_to :question}
  it {should have_many :response}
end
