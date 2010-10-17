class Sheet < ActiveRecord::Base
  
  has_paper_trail
  has_attached_file :avatar
  
  belongs_to :control
  
end
