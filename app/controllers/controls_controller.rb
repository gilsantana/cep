class ControlsController < ApplicationController

  def index
    @controls = Control.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @controls }
    end
  end

  def show
    @control = Control.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @control }
    end
  end

  def new
    @control = Control.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @control }
    end
  end

  def edit
    @control = Control.find(params[:id])
  end

  def create
    @control = Control.new(params[:control])

    respond_to do |format|
      if @control.save
        format.html { redirect_to(@control, :notice => 'Controle criado com sucesso.') }
        format.xml  { render :xml => @control, :status => :created, :location => @control }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @control.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @control = Control.find(params[:id])

    respond_to do |format|
      if @control.update_attributes(params[:control])
        format.html { redirect_to(@control, :notice => 'Controle atualizado com sucesso.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @control.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @control = Control.find(params[:id])
    @control.destroy

    respond_to do |format|
      format.html { redirect_to(controls_url) }
      format.xml  { head :ok }
    end
  end
  
  def variaveis_tipo_1_media
    @control = Control.find(params[:id])
    
    @lc_media = @control.indice :lc, :variaveis, :tipo1, :media
    @lci_media = @control.indice :lci, :variaveis, :tipo1, :media
    @lcs_media = @control.indice :lcs, :variaveis, :tipo1, :media
    
    render "controls/variaveis/tipo1/media"
  end
  
  def variaveis_tipo_1_amplitude
    @control = Control.find(params[:id])

    @lc_amplitude = @control.indice :lc, :variaveis, :tipo1, :amplitude
    @lci_amplitude = @control.indice :lci, :variaveis, :tipo1, :amplitude
    @lcs_amplitude = @control.indice :lcs, :variaveis, :tipo1, :amplitude
    
    render "controls/variaveis/tipo1/amplitude"
  end
  
end
