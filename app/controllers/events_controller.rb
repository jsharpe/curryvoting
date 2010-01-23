class EventsController < ApplicationController
  before_filter :authenticate, :only => [:show]
  before_filter [:authenticate, :super_user], :only => [:new, :edit, :destroy, :create, :update, :openvoting, :closevoting]

  # GET /events
  # GET /events.xml
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    @myvote = Vote.find_by_userid(session[:userid])
    if @myvote.nil? then
      @myvote = Vote.new
      @myvote.event_id= params[:id]
      @myvote.userid= session[:userid]
    end
    @myvote.save

    @vote = @myvote

    @graph = open_flash_chart_object(600,300,"/events/%i/results"%params[:id].to_i)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      @event.curryhouse_ids = params[:event][:curryhouse_ids]
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  def openvoting
  	@event = Event.find(params[:id])
	@event.votingopen = true
	@event.save
	flash[:notice] = "Voting now open!"
	redirect_to event_path
  end

  def closevoting
  	@event = Event.find(params[:id])
	@event.votingopen = false
	@event.save
	flash[:notice] = "Voting now closed"
	redirect_to event_path
  end

  def results
  	@event = Event.find(params[:id])
	vote_results = Array.new
	@event.curryhouses.each do |curryhouse|
		count = 0
	        Vote.find(@event.votes).map(&:curryhouse_ids).flatten!.each { |v| count = count +1 if v==curryhouse.id } rescue nil
                vote_results << HBarValue.new(0,count)
	end

	title = Title.new("Results")
	hbar = HBar.new
	hbar.values  = vote_results

	chart = OpenFlashChart.new
	chart.set_title(title)
	chart.add_element(hbar)

	y = YAxis.new
	y.set_offset(true)
	y.set_labels @event.curryhouses.map(&:title).reverse
	chart.set_y_axis(y)

	x = XAxis.new
	x.set_range(0,10,1)
	chart.set_x_axis(x)

	render :text => chart.to_s
  end

private
  def super_user
	puts session[:userid]
  	if !(session[:userid].to_i == 1000)
	    render :inline => "Access Denied", :status=> 401, :layout => false
	end
  end

  def authenticate_new
	session[:userid]=2
	session[:username]="Test"
  end

  def authenticate
  	require 'password'
	require 'nis'
  	authenticate_or_request_with_http_basic "Curry" do |id, password|
	  #retrieve the password from NIS
	  ypdomain = YP.get_default_domain
	  ans = false

	  YP.yp_all(ypdomain, 'shadow.byname') do |status, key, val|
	  	case status
		when YP::YPERR_SUCCESS
			return false
		else
			if(key == id)
				if(val.split(':')[1] == "!") 
					ans = false
					ans
				else
				if(val.split(':')[1].split('$')[1] == '1')
					crypttype = Password::MD5
					salt = (val.split(':')[1]).split('$')[2]
				else
					crypttype = Password::DES
					salt = val.split(':')[1][0..1]
				end
				ans = (Password.new(password).crypt(crypttype, salt).eql? val.split(':')[1])
				end
			end
		end
	  end

	  YP.yp_all(ypdomain, 'passwd.byname') do |status, key, val|
	        case status
		when YP::YPERR_SUCCESS
			return false
		else
			if(key == id)
				if(val.split(':')[1] == "!") 
					ans = false
					ans
				else
				session[:userid] = val.split(':')[2].to_i
				session[:username] = val.split(':')[4]
				end
			end
		end
	  end

	  ans
	end
  end
end
