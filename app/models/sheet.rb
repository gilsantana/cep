class Sheet < ActiveRecord::Base
  
  has_paper_trail
  
  belongs_to :control
  
  has_attached_file :arquivo

  
end
