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
    # get the unique ratings values from the movie database
    @all_ratings = Movie.uniq.pluck(:rating)
    # get the title that was clicked from the index view 
    if params[:title]
      @title = params[:title]
      session[:title] = params[:title]
    end
    # get the selected ratings ad store it in the session hash
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    # sort the table in the view based on the header that was clicked
    if session[:title] && session[:ratings]
      case session[:title]
        when "Movie Title" then @movies = Movie.where(rating: session[:ratings].keys).order(title: :asc)
        when "Release Date" then @movies = Movie.where(rating: session[:ratings].keys).order(release_date: :asc)
      end
    elsif session[:title]
      case session[:title]
        when "Movie Title" then @movies = Movie.all.order(title: :asc)
        when "Release Date" then @movies = Movie.all.order(release_date: :asc)
      end
    elsif session[:ratings]
      @movies = Movie.where(rating: session[:ratings].keys)
    else
      @movies = Movie.all
    end
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
