class Sheet < ActiveRecord::Base
  
  has_paper_trail
  has_attached_file :arquivo
  
  belongs_to :control

  
end
