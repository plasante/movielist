class MoviesController < ApplicationController
  before_filter :authenticate, :only => [:edit]
  before_filter :admin_user,   :only => :destroy
  
  # GET /movies
  # GET /movies.xml
  def index
    @movies = Movie.all
    @title = %(Movies)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.xml
  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        format.html { redirect_to(@movie, :notice => 'Movie was successfully created.') }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    begin
      @movie = Movie.find(params[:id])
  
      respond_to do |format|
        if @movie.update_attributes(params[:movie])
          format.html { redirect_to(@movie, :notice => 'Movie was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
        end
      end
    rescue ActiveRecord::StaleObjectError
      flash[:error] = %(Movie was already changed)
      redirect_to @movie
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end
  
private

  def admin_user
    redirect_to root_path if !current_user.administrator?
  end
end
