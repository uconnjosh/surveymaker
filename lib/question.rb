class Question < ActiveRecord::Base
  belongs_to :survey
  has_many :answer_options
end
