require 'spec_helper'

describe Question do
  it {should belong_to :survey}
  it {should have_many :answer_options}
end
