SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    primary.item :root, 'Home', root_path, :class=>"first" do |principal|
      principal.item :controls, "Controles", controls_path do |controles|
        controles.item :controls, "Novo Controle", new_control_path

        if @control.id
          controles.item :controls, @control.nome, @control do |controle|
            controle.item :controls, "Editar", edit_control_path(@control)
            controle.item :samples, "Amostras", control_samples_path(@control) do |amostra|
              amostra.item :new, "Nova Amostra", new_control_sample_path(@control)
            end
          end
        end

      end
    end
  end
end