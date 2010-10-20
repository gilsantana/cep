class Sample < ActiveRecord::Base

  has_paper_trail

  belongs_to :control

  has_many :items, :dependent=>:destroy
  has_many :limit_calculations, :dependent=>:destroy
  has_many :additional_informations


  def calcular_media
    self.media = self.items.average(:valor)
    self.amplitude = self.items.maximum(:valor)-self.items.minimum(:valor)
    self.desvio_padrao = self.items.select("stddev(valor) as desvio")[0].desvio.to_f
    self.mediana = self.calcular_mediana
    self.save

    # calcular os limites para Tipo 1 do Controle por Variáveis
  end
  
  def limite_superior tipo
    @constant = Constant.find_last_by_tamanho(self.items.size)
    resultado = case tipo
       when "media" then (self.control.media_das_medias+@constant.a2*self.control.media_das_amplitudes).round(2)
       when "amplitude" then (@constant.d4*self.control.media_das_amplitudes).round(2)
       when "desvio_padrao" then (@constant.b4*self.control.media_dos_desvios).round(2)
       when "mediana" then (self.control.media_das_medianas+@constant.a2*self.control.media_das_amplitudes).round(2)
    end
    ((self.control.ls_padrao!=nil and @control.ls_padrao>0) ? self.control.ls_padrao : resultado)
  end
  
  def limite_central tipo
    @constant = Constant.find_last_by_tamanho(self.items.size)
    case tipo
       when "media" then self.control.media_das_medias.round(2)
       when "amplitude" then self.control.media_das_amplitudes.round(2)
       when "desvio_padrao" then self.control.media_dos_desvios.round(2)
       when "mediana" then self.control.media_das_medianas.round(2)
    end
  end
  
  def limite_inferior tipo
    @constant = Constant.find_last_by_tamanho(self.items.size)
    resultado = case tipo
       when "media" then (self.control.media_das_medias-@constant.a2*self.control.media_das_amplitudes).round(2)
       when "amplitude" then (@constant.d3*self.control.media_das_amplitudes).round(2)
       when "desvio_padrao" then (@constant.b3*self.control.media_dos_desvios).round(2)
       when "mediana" then (self.control.media_das_medianas-@constant.a2*self.control.media_das_amplitudes).round(2)
    end
    (self.control.li_padrao!=nil ? self.control.li_padrao : resultado)
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
    @lci.valor = (@lc.valor-3*@calculo)<=0 ? 0 : (@lc.valor-3*@calculo)
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
    @lci.valor = (@lc.valor-3*@calculo)<=0 ? 0 : (@lc.valor-3*@calculo)
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
    @lci.valor = (@lc.valor-3*@calculo)<=0 ? 0 : (@lc.valor-3*@calculo)
    @lci.save
    
  end

end
