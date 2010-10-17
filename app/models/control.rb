class Control < ActiveRecord::Base
  
  has_paper_trail
  
  has_many :samples, :dependent=>:destroy
  has_many :sheets, :dependent=>:destroy
  
  has_many :limit_calculations, :through=>:samples
  has_many :items, :through=>:samples
  
  validates_presence_of :nome
  
  
  def indice limite, categoria, tipo, calculo
    self.limit_calculations.where({:categoria=>categoria, :tipo=>tipo, :calculo=>"#{limite}_of_#{calculo}"})
  end
  
  def media_das_medias
    self.samples.average(:media)
  end
  
  def media_das_amplitudes
    self.samples.average(:amplitude)
  end
  
  
end
