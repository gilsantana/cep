SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    primary.item :root, 'Home', root_path, :class=>"first" do |principal|
      principal.item :controls, "Controles", controls_path do |controle|
        controle.item :controls, "Novo Controle", new_control_path
      end
    end
  end
end