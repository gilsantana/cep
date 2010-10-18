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

        s = Openoffice.new(@sheet.arquivo.path)
        s.default_sheet = s.sheets.first
        (s.first_row..s.last_row).each do |linha|
          @sample = @control.samples.build
          if @sheet.first_column_is_date==false
            if linha==1
              @sample.tempo = @sheet.initial_time
            else
              @sample.tempo = @sheet.initial_time+((linha-1)*@sheet.increment_value).send(@sheet.incremente_type)
            end
          else
            @sample.tempo = s.cell(linha, 1)
          end
          @sample.save
          (s.first_column..s.last_column).each do |coluna|
            @item = @sample.items.build
            @item.valor = s.cell(linha,coluna)
            @item.save
          end
        end

        @control.samples.each do |amostra|
          amostra.calcular_media
        end
        @control.samples.each do |amostra|
          amostra.calcular_media
        end

        @control.samples.each do |amostra|
          amostra.calcular_limites
        end

        format.html { redirect_to(control_samples_path(@sheet.control), :notice => 'Planilha Importada com sucesso.') }
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
      format.html { redirect_to(sheets_url) }
      format.xml  { head :ok }
    end
  end
end
