SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    primary.item :root, 'Home', root_path, :class=>"first" do |principal|
      principal.item :controls, "Controles", controls_path do |controles|
        controles.item :controls, "Novo Controle", new_control_path
        controles.item :controls, @control.nome, @control do |controle|
          controle.item :controls, "Editar", edit_control_path(@control)
        end
        
      end
    end
  end
end