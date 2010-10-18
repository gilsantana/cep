class Sample < ActiveRecord::Base

  has_paper_trail

  belongs_to :control

  has_many :items, :dependent=>:destroy
  has_many :limit_calculations, :dependent=>:destroy


  def calcular_media
    self.media = self.items.average(:valor)
    self.amplitude = self.items.maximum(:valor)-self.items.minimum(:valor)
    self.desvio_padrao = self.items.select("stddev(valor) as desvio")[0].desvio.to_f
    self.mediana = self.calcular_mediana
    self.save

    # calcular os limites para Tipo 1 do Controle por Variáveis
  end

  def calcular_limites

    @constant = Constant.find_last_by_tamanho(self.items.size)

    @lc_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_media}).limit(1).last
    if @lc_media==nil
      @lc_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo1, :calculo=>:lc_of_media})
    end
    @lc_media.valor = self.control.media_das_medias
    @lc_media.save

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


    # Controle por Variavel - Tipo 2 
    @lc_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lc_of_media}).limit(1).last
    if @lc_media==nil
      @lc_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lc_of_media})
    end
    @lc_media.valor = self.control.media_das_medias
    @lc_media.save

    @constant = Constant.find_last_by_tamanho(self.items.size)
    @lcs_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lcs_of_media}).limit(1).last
    if @lcs_media==nil
      @lcs_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lcs_of_media})
    end
    @lcs_media.valor = self.control.media_das_medias+@constant.a3*self.control.media_dos_desvios
    @lcs_media.save

    @lci_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lci_of_media}).limit(1).last
    if @lci_media==nil
      @lci_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lci_of_media})
    end
    @lci_media.valor = self.control.media_das_medias-@constant.a3*self.control.media_dos_desvios
    @lci_media.save


    @lc_amplitude = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lc_of_desvio_padrao}).limit(1).last
    if @lc_amplitude==nil
      @lc_amplitude = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lc_of_desvio_padrao})
    end
    @lc_amplitude.valor = self.control.media_dos_desvios
    @lc_amplitude.save

    @lcs_amplitude = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lcs_of_desvio_padrao}).limit(1).last
    if @lcs_amplitude==nil
      @lcs_amplitude = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lcs_of_desvio_padrao})
    end
    @lcs_amplitude.valor = @constant.b4*self.control.media_dos_desvios
    @lcs_amplitude.save

    @lci_amplitude = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lci_of_desvio_padrao}).limit(1).last
    if @lci_amplitude==nil
      @lci_amplitude = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo2, :calculo=>:lci_of_desvio_padrao})
    end
    @lci_amplitude.valor = @constant.b3*self.control.media_dos_desvios
    @lci_amplitude.save
    
    
    
    #-----------------------
    @constant = Constant.find_last_by_tamanho(self.items.size)

    @lc_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo3, :calculo=>:lc_of_mediana}).limit(1).last
    if @lc_media==nil
      @lc_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo3, :calculo=>:lc_of_mediana})
    end
    @lc_media.valor = self.control.media_das_medias
    @lc_media.save

    @lcs_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo3, :calculo=>:lcs_of_mediana}).limit(1).last
    if @lcs_media==nil
      @lcs_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo3, :calculo=>:lcs_of_mediana})
    end
    @lcs_media.valor = self.control.media_das_medias+@constant.a2*self.control.media_das_amplitudes
    @lcs_media.save

    @lci_media = self.limit_calculations.where({:categoria=>:variaveis, :tipo=>:tipo3, :calculo=>:lci_of_mediana}).limit(1).last
    if @lci_media==nil
      @lci_media = self.limit_calculations.build({:categoria=>:variaveis, :tipo=>:tipo3, :calculo=>:lci_of_mediana})
    end
    @lci_media.valor = self.control.media_das_medias-@constant.a2*self.control.media_das_amplitudes
    @lci_media.save

  end

  def calcular_mediana
    items = self.items.order("valor ASC")
    n = (items.length - 1) / 2 # Middle of the array
    n2 = (items.length) / 2 # Other middle of the array.
    # Used only if amount in array is even
    if items.length % 2 == 0 # If number is even
      median = (items[n].valor + items[n2].valor) / 2
    else
      median = items[n].valor
    end
    return median
  end
  
  
  def calcular_carta_p
    @lc = self.limit_calculations.where({:categoria=>:atributos, :tipo=>:p, :calculo=>:lc}).limit(1).last
    if @lc==nil
      @lc = self.limit_calculations.build({:categoria=>:atributos, :tipo=>:p, :calculo=>:lc})
    end
    @lc.valor = self.control.fracao_de_nao_conformes
    @lc.save
    
    @calculo = Math.sqrt((self.control.fracao_de_nao_conformes*(1-self.control.fracao_de_nao_conformes))/self.tamanho_da_amostra)
    
    @lcs = self.limit_calculations.where({:categoria=>:atributos, :tipo=>:p, :calculo=>:lcs}).limit(1).last
    if @lcs==nil
      @lcs = self.limit_calculations.build({:categoria=>:atributos, :tipo=>:p, :calculo=>:lcs})
    end
    @lcs.valor = @lc.valor+3*@calculo
    @lcs.save
    
    @lci = self.limit_calculations.where({:categoria=>:atributos, :tipo=>:p, :calculo=>:lci}).limit(1).last
    if @lci==nil
      @lci = self.limit_calculations.build({:categoria=>:atributos, :tipo=>:p, :calculo=>:lci})
    end
    @lci.valor = @lc.valor-3*@calculo
    @lci.save
    
  end
  
  def calcular_carta_np
    @lc = self.limit_calculations.where({:categoria=>:atributos, :tipo=>:np, :calculo=>:lc}).limit(1).last
    if @lc==nil
      @lc = self.limit_calculations.build({:categoria=>:atributos, :tipo=>:np, :calculo=>:lc})
    end
    @lc.valor = self.control.media_de_itens_defeituosos
    @lc.save
    
    @calculo = self.control.desvio_padrao_de_nao_conformidades
    
    @lcs = self.limit_calculations.where({:categoria=>:atributos, :tipo=>:np, :calculo=>:lcs}).limit(1).last
    if @lcs==nil
      @lcs = self.limit_calculations.build({:categoria=>:atributos, :tipo=>:np, :calculo=>:lcs})
    end
    @lcs.valor = @lc.valor+3*@calculo
    @lcs.save
    
    @lci = self.limit_calculations.where({:categoria=>:atributos, :tipo=>:np, :calculo=>:lci}).limit(1).last
    if @lci==nil
      @lci = self.limit_calculations.build({:categoria=>:atributos, :tipo=>:np, :calculo=>:lci})
    end
    @lci.valor = @lc.valor-3*@calculo
    @lci.save
    
  end
  
  def calcular_carta_c
    
    @calculo = self.control.raiz_quadrada_da_media_das_conformidades
    
    @lc = self.limit_calculations.where({:categoria=>:atributos, :tipo=>:c, :calculo=>:lc}).limit(1).last
    if @lc==nil
      @lc = self.limit_calculations.build({:categoria=>:atributos, :tipo=>:c, :calculo=>:lc})
    end
    @lc.valor = self.control.media_de_itens_defeituosos
    @lc.save
    
    
    
    @lcs = self.limit_calculations.where({:categoria=>:atributos, :tipo=>:c, :calculo=>:lcs}).limit(1).last
    if @lcs==nil
      @lcs = self.limit_calculations.build({:categoria=>:atributos, :tipo=>:c, :calculo=>:lcs})
    end
    @lcs.valor = @lc.valor+3*@calculo
    @lcs.save
    
    @lci = self.limit_calculations.where({:categoria=>:atributos, :tipo=>:c, :calculo=>:lci}).limit(1).last
    if @lci==nil
      @lci = self.limit_calculations.build({:categoria=>:atributos, :tipo=>:c, :calculo=>:lci})
    end
    @lci.valor = @lc.valor-3*@calculo
    @lci.save
    
  end

end
