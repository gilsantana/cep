class Sample < ActiveRecord::Base
  
  has_paper_trail
  
  belongs_to :control
  
end
