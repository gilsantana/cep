module ApplicationHelper

  def marcador_vermelho valor
    "{y: #{valor},marker: {symbol: 'url(#{image_path('icons/close4.png')})'}}"
  end

  def formatar_dados dados, valor, dados_comparacao=nil, campo_comparacao=nil
    array = Array.new
    dados.order("tempo ASC").each_with_index do |i, index|
      if dados_comparacao!=nil
        array << (dados_comparacao.order("tempo ASC")[index].send(campo_comparacao).round(2) < i.send(valor).round(2) ? marcador_vermelho(i.send(valor).round(2)) : i.send(valor).round(2))
      else
        array << i.send(valor).round(2)
      end
    end
    return "["+array.join(',')+"]"
  end

end
