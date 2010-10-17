class Control < ActiveRecord::Base
  
  has_paper_trail
  
  has_many :samples
  
  validates_presence_of :nome
  
end
