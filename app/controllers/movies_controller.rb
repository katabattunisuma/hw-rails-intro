class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      ratings = params[:ratings]
      @all_ratings = Movie.all_ratings

    if (request.referrer).nil?
      session.clear
    end

    #Store current rating and sort parameters in session to be remembered
    if !params[:ratings].nil?
      session[:ratings] = ratings 
    end

    if !params[:sort].nil?
      session[:sort] = params[:sort]
    end

    order_by = params[:sort]
    #When all boxes are unchecked we want to display as all ratings are checked
    if (params[:ratings].nil? and params[:commit]=="Refresh")
      @check_boxes = []
      @movies = Movie.use_ratings(@check_boxes, session[:sort])
      session[:ratings] = params[:rating]
      flash[:notice] = "All Checkboxes Were Empty! Please select at least one rating!"
    #When returning from another pager it should remember the ratings/sort 
    elsif (!session[:sort].nil? && params[:sort].nil?) || ( !session[:ratings].nil? && params[:ratings].nil?) 
      flash[:notice] = nil
      redirect_to movies_path("ratings" => session[:ratings], "sort" => session[:sort])

    else
      flash[:notice] = nil
      if !params[:ratings].nil?
        ratings = params[:ratings].keys
      else
        ratings = @all_ratings
      end
      if order_by=='release_date'
        @order_by = order_by
        @selected = 'release_date'
      elsif order_by == 'title'
        @order_by = order_by
        @selected = 'title'
      else
        @order_by = ""
        @check_boxes = ratings
        @selected = nil
      end

      @check_boxes = ratings
      @movies = Movie.use_ratings(@check_boxes, @order_by)


    end
    
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(params1)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(params1)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end