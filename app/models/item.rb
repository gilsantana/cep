class Item < ActiveRecord::Base
  
  has_paper_trail
  
  belongs_to :sample
end
