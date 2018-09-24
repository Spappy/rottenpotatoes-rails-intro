class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    ratings_set = Movie.select(:rating).uniq
    @ratings = []
    if !params.has_key?(:ratings) || !params.has_key?(:sort)
      if !params.has_key?(:ratings) && session[:ratings]
        params[:ratings] = session[:ratings]
        flash[:keys_check] = false
      elsif !params.has_key?(:ratings)
        ratings_set.each do |movie|
        @ratings.push(movie.rating)
        
        end
        flash[:keys_check] = false
        params[:ratings] = @ratings
      else
        flash[:keys_check] = true
      end
      if !params.has_key?(:sort) && session[:sort]
        params[:sort] = session[:sort]
      elsif !params.has_key?(:sort)
        params[:sort] = ""
      end
      flash.keep
      redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    end

    @ratings = params[:ratings]
    
    if @ratings.respond_to?('keys')
      @ratings = @ratings.keys
    end
    flash[:keys_check] = false
    @sort_choice = params[:sort]
    @all_ratings = []
    ratings_set.each do |movie|
      @all_ratings.push(movie.rating)
    end

    case @sort_choice
    when 'title'
      @movies = Movie.where(rating: @ratings).order(:title)
    when 'release_date'
      @movies = Movie.where(rating: @ratings).order(:release_date)
    else
      @movies = Movie.where(rating: @ratings)
    end
    session[:sort] = @sort_choice
    session[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
