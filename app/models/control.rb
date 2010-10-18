class Control < ActiveRecord::Base

  has_paper_trail

  has_many :samples, :dependent=>:destroy
  has_many :sheets, :dependent=>:destroy
  has_many :limit_calculations, :through=>:samples
  has_many :items, :through=>:samples

  belongs_to :user

  validates_presence_of :nome


  def indice limite, categoria, tipo, calculo=nil
    if calculo!=nil
      self.limit_calculations.where({:categoria=>categoria, :tipo=>tipo, :calculo=>"#{limite}_of_#{calculo}"})
    else
      self.limit_calculations.where({:categoria=>categoria, :tipo=>tipo, :calculo=>limite})
    end
  end

  def indice_por_atributo limite, categoria, tipo
    self.limit_calculations.where({:categoria=>categoria, :tipo=>tipo, :calculo=>limite})
  end

  def media_das_medias
    self.samples.average(:media)
  end

  def media_das_amplitudes
    self.samples.average(:amplitude)
  end

  def media_dos_desvios
    self.samples.average(:desvio_padrao)
  end

  def media_das_medianas
    self.samples.average(:mediana)
  end

  def fracao_de_nao_conformes
    self.samples.sum(:itens_defeituosos)/self.samples.sum(:tamanho_da_amostra)
  end

  def media_de_itens_defeituosos
    self.samples.average(:itens_defeituosos)
  end

  def desvio_padrao_de_nao_conformidades
    self.samples.select("stddev(itens_defeituosos) as desvio")[0].desvio.to_f
  end

  def raiz_quadrada_da_media_das_conformidades
    Math.sqrt(self.samples.average(:itens_defeituosos))
  end


end
