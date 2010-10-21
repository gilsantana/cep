class SheetsController < ApplicationController
  before_filter :find_control
  
  def find_control
    @control = Control.find(params[:control_id])
  end

  def index
    @sheets = @control.sheets.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sheets }
    end
  end

  def show
    @sheet = Sheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sheet }
    end
  end

  def new
    @sheet = @control.sheets.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sheet }
    end
  end

  def edit
    @sheet = Sheet.find(params[:id])
  end

  def create
    @sheet = @control.sheets.create(params[:sheet])

    respond_to do |format|
      if @sheet.save
        format.html { redirect_to([@sheet.control, @sheet], :notice => 'Planilha Importada com sucesso.') }
        format.xml  { render :xml => @sheet, :status => :created, :location => @sheet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @sheet = Sheet.find(params[:id])

    respond_to do |format|
      if @sheet.update_attributes(params[:sheet])
        format.html { redirect_to(@sheet, :notice => 'Planilha atualizada com sucesso.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @sheet = Sheet.find(params[:id])
    @sheet.destroy

    respond_to do |format|
      format.html { redirect_to(control_sheets_url(@control)) }
      format.xml  { head :ok }
    end
  end

  def processar
    @sheet = Sheet.find(params[:id])
    planilha = @sheet.arquivo.planilha
    
    ((planilha.first_row+1)..planilha.last_row).each do |index|
      @sample=@control.samples.build
      if params[:data]
        @sample.tempo = planilha.cell(index, params[:data][0].to_i)
      end
      if params[:lote]
        @sample.lote = planilha.cell(index, params[:lote][0].to_i)
      end
      @sample.save
      if params[:adicional]
        params[:adicional].each do |adicional|
          @additional_information = AdditionalInformation.new(:informacao=>planilha.cell(1, adicional), :conteudo=>planilha.cell(index, adicional), :sample_id=>@sample.id)
          @additional_information.save
        end
      end
      
      if params[:amostra]
        params[:amostra].each do |adicional|
          if planilha.cell(index, adicional.to_i)!=nil
            @item = Item.new(:valor=>planilha.cell(index, adicional.to_i), :sample_id=>@sample.id)
            @item.save
          end
        end
      end
      @sample.calcular_media
    end
    redirect_to control_samples_path(@control)
  end

end
