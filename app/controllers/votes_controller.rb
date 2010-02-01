class VotesController < ApplicationController
  before_filter :load_event

  before_filter :authenticate, :only => [:create, :new, :edit, :update]
  before_filter [:authenticate, :super_user], :only => [:destroy, :show]

  def load_event
    @event = Event.find(params[:event_id])
  end

  # GET /votes
  # GET /votes.xml
  def index
    @votes = Vote.find(:all, :conditions => {:event_id => @event} )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.xml
  def show
    @vote = Vote.find(params[:id], :conditions => { :event_id => @event } )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.xml
  def create
    @vote = Vote.new(params[:vote])
    @vote.event = @event
    @vote.curryhouse_ids = params[:vote][:curryhouse_ids]
    @vote.userid = session[:userid]
    respond_to do |format|
      if @vote.save
        flash[:notice] = 'Vote was successfully cast.'
        format.html { redirect_to @event }
        format.xml  { render :xml => @vote, :status => :created, :location => @vote }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.xml
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        flash[:notice] = 'Vote was successfully updated.'
        format.html { redirect_to @event }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.xml
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to(event_votes_url(@event)) }
      format.xml  { head :ok }
    end
  end

private

  def super_user
	puts session[:userid]
  	if !(session[:userid].to_i == 1000)
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
