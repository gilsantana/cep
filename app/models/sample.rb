class Sample < ActiveRecord::Base
  
  has_paper_trail
  
  belongs_to :control
  
  has_many :items, :dependent=>:destroy
  has_many :limit_calculations, :dependent=>:destroy

  
  def calcular
    self.media = self.items.average(:valor)
    self.amplitude = self.items.maximum(:valor)-self.items.minimum(:valor)
    self.save
    
    # calcular os limites para Tipo 1 do Controle por Variáveis
    @lc = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_media}).limit(1)
    unless @lc==nil
      @lc = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_media})
    end
    @lc.valor = self.media
    @lc.save
    
    @constant = Constant.find_last_by_tamanho(self.items.size)
    @lcs = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lcs_of_media}).limit(1)
    unless @lc==nil
      @lcs = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lcs_of_media})
    end
    @lcs.valor = self.media+@constant.a2*self.amplitude
    @lcs.save
    
    @lci = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lci_of_media}).limit(1)
    unless @lc==nil
      @lci = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lci_of_media})
    end
    @lci.valor = self.media+@constant.a2*self.amplitude
    @lci.save
    
    
    @lc = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_amplitude}).limit(1)
    unless @lc==nil
      @lc = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_amplitude})
    end
    @lc.valor = self.amplitude
    @lc.save
    
    @constant = Constant.find_last_by_tamanho(self.items.size)
    @lcs = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_amplitude}).limit(1)
    unless @lc==nil
      @lcs = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_amplitude})
    end
    @lcs.valor = @constant.d4*self.amplitude
    @lcs.save
    
    @lci = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_amplitude}).limit(1)
    unless @lc==nil
      @lci = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_amplitude})
    end
    @lci.valor = @constant.d3*self.amplitude
    @lci.save
    #--------------------------
    
  end
  
end
