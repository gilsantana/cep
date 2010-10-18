SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    primary.item :root, 'Home', root_path, :class=>"first" do |principal|
      principal.item :controls, "Controles", controls_path do |controles|
        controles.item :controls, "Novo Controle", new_control_path
        
        if @control and @control.id
          controles.item :controls, @control.nome, @control do |controle|
            controle.item :controls, "Editar", edit_control_path(@control)
            
            controle.item :controls, "Análise de dados", variaveis_tipo_1_media_control_path(@control)
            controle.item :controls, "Análise de dados", variaveis_tipo_2_media_control_path(@control)
            controle.item :controls, "Análise de dados", variaveis_tipo_3_mediana_control_path(@control)
            controle.item :controls, "Análise de dados", atributos_p_control_path(@control)
            controle.item :controls, "Análise de dados", atributos_np_control_path(@control)
            controle.item :controls, "Análise de dados", atributos_c_control_path(@control)
            
            controle.item :samples, "Amostras", control_samples_path(@control) do |amostra|
              amostra.item :new, "Nova Amostra", new_control_sample_path(@control)
            end
          end
        end

      end
    end
  end
end