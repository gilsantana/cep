class Sample < ActiveRecord::Base
  
  has_paper_trail
  
  belongs_to :control
  
  has_many :items, :dependent=>:destroy
  has_many :limit_calculations, :dependent=>:destroy

  
  def calcular_media
    self.media = self.items.average(:valor)
    self.amplitude = self.items.maximum(:valor)-self.items.minimum(:valor)
    self.save
    
    # calcular os limites para Tipo 1 do Controle por Variáveis
    @lc_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_media}).limit(1).last
    if @lc_media==nil
      @lc_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_media})
    end
    @lc_media.valor = self.control.media_das_medias
    @lc_media.save
    
  end
  
  def calcular_limites
    @constant = Constant.find_last_by_tamanho(self.items.size)
    @lcs_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lcs_of_media}).limit(1).last
    if @lcs_media==nil
      @lcs_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lcs_of_media})
    end
    @lcs_media.valor = self.control.media_das_medias+@constant.a2*self.control.media_das_amplitudes
    @lcs_media.save
    
    @lci_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lci_of_media}).limit(1).last
    if @lci_media==nil
      @lci_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lci_of_media})
    end
    @lci_media.valor = self.control.media_das_medias-@constant.a2*self.control.media_das_amplitudes
    @lci_media.save
    
    
    @lc_amplitude = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_amplitude}).limit(1).last
    if @lc_amplitude==nil
      @lc_amplitude = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_amplitude})
    end
    @lc_amplitude.valor = self.control.media_das_amplitudes
    @lc_amplitude.save

    @lcs_amplitude = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lcs_of_amplitude}).limit(1).last
    if @lcs_amplitude==nil
      @lcs_amplitude = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lcs_of_amplitude})
    end
    @lcs_amplitude.valor = @constant.d4*self.control.media_das_amplitudes
    @lcs_amplitude.save
    
    @lci_amplitude = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lci_of_amplitude}).limit(1).last
    if @lci_amplitude==nil
      @lci_amplitude = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lci_of_amplitude})
    end
    @lci_amplitude.valor = @constant.d3*self.control.media_das_amplitudes
    @lci_amplitude.save
    #--------------------------
    
  end
  
end
