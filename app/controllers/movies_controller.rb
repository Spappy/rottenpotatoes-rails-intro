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
    @ratings = []
    ratings_set = Movie.select(:rating).uniq
    if params.has_key?(:ratings)
      @ratings = params[:ratings];
      @ratings = @ratings.keys
      @sort_choice = flash[:sort]
    elsif flash[:ratings]
        @ratings = flash[:ratings]
    else
      ratings_set.each do |movie|
        @ratings.push(movie.rating)
      end
    end
    
    @all_ratings = []
    ratings_set.each do |movie|
      @all_ratings.push(movie.rating)
    end
    
    if params[:sort] == 'title' || params[:sort] == 'release_date'
      @sort_choice = params[:sort]
    end
    case @sort_choice
    when 'title'
      @movies = Movie.where(rating: @ratings).order(:title)
    when 'release_date'
      @movies = Movie.where(rating: @ratings).order(:release_date)
    else
      @movies = Movie.where(rating: @ratings)
    end
    flash[:sort] = @sort_choice
    flash[:ratings] = @ratings
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
