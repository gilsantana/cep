module ApplicationHelper

  def marcador_vermelho valor
    "{y: #{valor},marker: {symbol: 'url(#{image_path('icons/close4.png')})'}}"
  end

  def formatar_dados dados, valor, calculo
    array = Array.new
    dados.order("tempo ASC").each_with_index do |i, index|
      if calculo.class.to_s=="Hash"
        array << (((i.send(calculo[:comparar_maior].to_s, valor.to_s) < i.send(valor.to_s).round(2)) or i.send(calculo[:comparar_menor].to_s, valor.to_s) > i.send(valor.to_s).round(2)) ? marcador_vermelho(i.send(valor.to_s)) : i.send(valor.to_s))
      else
        array << i.send(valor.to_s, calculo.to_s)
      end
    end
    return "["+array.join(',')+"]"
  end

end
