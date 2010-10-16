class Control < ActiveRecord::Base
  has_paper_trail
  validates_presence_of :nome
end
