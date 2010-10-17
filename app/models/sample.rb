class Sample < ActiveRecord::Base
  
  has_paper_trail
  
  belongs_to :control
  
  has_many :items, :dependent=>:destroy
  
  def calcular
    self.media = self.items.average(:valor)
    self.amplitude = self.items.maximum(:valor)-self.items.minimum(:valor)
    self.save
  end
  
end
