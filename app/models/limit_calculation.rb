class LimitCalculation < ActiveRecord::Base
  has_paper_trail
  belongs_to :sample
end
