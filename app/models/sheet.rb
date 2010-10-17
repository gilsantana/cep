class Sheet < ActiveRecord::Base
  
  has_paper_trail
  has_attached_file :file
  
  belongs_to :control
  
end
