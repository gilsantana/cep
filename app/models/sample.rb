class Sample < ActiveRecord::Base
  
  has_paper_trail
  
  belongs_to :control
  
  has_many :items, :dependent=>:destroy
  
end
