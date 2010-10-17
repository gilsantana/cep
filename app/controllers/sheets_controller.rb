class SheetsController < ApplicationController

  def index
    @sheets = Sheet.all

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
    @sheet = Sheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sheet }
    end
  end

  def edit
    @sheet = Sheet.find(params[:id])
  end

  def create
    @sheet = Sheet.new(params[:sheet])

    respond_to do |format|
      if @sheet.save
        format.html { redirect_to(@sheet, :notice => 'Sheet was successfully created.') }
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
        format.html { redirect_to(@sheet, :notice => 'Sheet was successfully updated.') }
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
