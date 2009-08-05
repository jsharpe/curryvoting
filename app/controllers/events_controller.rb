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

# Load ZiYa necessary helpers
  helper Ziya::HtmlHelpers::Charts
  helper Ziya::YamlHelpers::Charts

  def results
  	@event = Event.find(params[:id])
	vote_results = Array.new
	@event.curryhouses.each do |curryhouse|
		count = 0
	        Vote.find(@event.votes).map(&:curryhouse_ids).flatten!.each { |v| count = count +1 if v==curryhouse.id } rescue nil
                vote_results << count
	end

	chart = Ziya::Charts::Bar.new("BAR", "my_bar")
	chart.add :axis_category_text, @event.curryhouses.map(&:title)
	chart.add :series, "Results", vote_results
	#chart.add :theme, 'swf'
	respond_to do |format|
		format.xml { render :xml => chart.to_xml }
	end
  end

private
  def super_user
	puts @id
  	if !(@id.to_i == 1006)
	    render :inline => "Access Denied", :status=> 401, :layout => false
	end
  end

  def authenticate
  	require 'password'
	require 'nis'
  	authenticate_or_request_with_http_basic "Curry" do |id, password|
	  #retrieve the password from NIS
	  ypdomain = YP.get_default_domain
	  ans = false
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
				if(val.split(':')[1].split('$')[1] == '1')
					crypttype = Password::MD5
					salt = (val.split(':')[1]).split('$')[2]
				else
					crypttype = Password::DES
					salt = val.split(':')[1][0..1]
				end
				ans = (Password.new(password).crypt(crypttype, salt).eql? val.split(':')[1])
				@id = val.split(':')[2].to_i
				@username = val.split(':')[4]
				puts @username
				end
			end
		end
	  end
	  ans
	end
  end
end
