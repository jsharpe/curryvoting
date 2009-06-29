class CurryhousesController < ApplicationController
  # GET /curryhouses
  # GET /curryhouses.xml
  def index
    @curryhouses = Curryhouse.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @curryhouses }
    end
  end

  # GET /curryhouses/1
  # GET /curryhouses/1.xml
  def show
    @curryhouse = Curryhouse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @curryhouse }
    end
  end

  # GET /curryhouses/new
  # GET /curryhouses/new.xml
  def new
    @curryhouse = Curryhouse.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @curryhouse }
    end
  end

  # GET /curryhouses/1/edit
  def edit
    @curryhouse = Curryhouse.find(params[:id])
  end

  # POST /curryhouses
  # POST /curryhouses.xml
  def create
    @curryhouse = Curryhouse.new(params[:curryhouse])

    respond_to do |format|
      if @curryhouse.save
        flash[:notice] = 'Curryhouse was successfully created.'
        format.html { redirect_to(@curryhouse) }
        format.xml  { render :xml => @curryhouse, :status => :created, :location => @curryhouse }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @curryhouse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /curryhouses/1
  # PUT /curryhouses/1.xml
  def update
    @curryhouse = Curryhouse.find(params[:id])

    respond_to do |format|
      if @curryhouse.update_attributes(params[:curryhouse])
        flash[:notice] = 'Curryhouse was successfully updated.'
        format.html { redirect_to(@curryhouse) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @curryhouse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /curryhouses/1
  # DELETE /curryhouses/1.xml
  def destroy
    @curryhouse = Curryhouse.find(params[:id])
    @curryhouse.destroy

    respond_to do |format|
      format.html { redirect_to(curryhouses_url) }
      format.xml  { head :ok }
    end
  end
end
