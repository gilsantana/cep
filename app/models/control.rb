class Control < ActiveRecord::Base
  
  has_paper_trail
  
  has_many :samples
  has_many :sheets
  
  validates_presence_of :nome
  
end
