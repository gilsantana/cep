class ControlsController < ApplicationController
  # GET /controls
  # GET /controls.xml
  def index
    @controls = Control.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @controls }
    end
  end

  # GET /controls/1
  # GET /controls/1.xml
  def show
    @control = Control.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @control }
    end
  end

  # GET /controls/new
  # GET /controls/new.xml
  def new
    @control = Control.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @control }
    end
  end

  # GET /controls/1/edit
  def edit
    @control = Control.find(params[:id])
  end

  # POST /controls
  # POST /controls.xml
  def create
    @control = Control.new(params[:control])

    respond_to do |format|
      if @control.save
        format.html { redirect_to(@control, :notice => 'Control was successfully created.') }
        format.xml  { render :xml => @control, :status => :created, :location => @control }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @control.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /controls/1
  # PUT /controls/1.xml
  def update
    @control = Control.find(params[:id])

    respond_to do |format|
      if @control.update_attributes(params[:control])
        format.html { redirect_to(@control, :notice => 'Control was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @control.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /controls/1
  # DELETE /controls/1.xml
  def destroy
    @control = Control.find(params[:id])
    @control.destroy

    respond_to do |format|
      format.html { redirect_to(controls_url) }
      format.xml  { head :ok }
    end
  end
end
