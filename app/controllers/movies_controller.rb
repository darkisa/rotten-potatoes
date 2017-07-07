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
    @all_ratings = Movie.get_ratings # get the unique ratings values from the movie database
    @selected_ratings = check_nil(params[:ratings], @all_ratings)
    @title = params[:title]
    set_session(@title, @selected_ratings)
    @movies = Movie.sort_and_filter(session[:title], session[:ratings])
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

  def check_nil(object, all_ratings)
    if object 
      return object.keys.to_a
    elsif session[:ratings]
      return session[:ratings]
    else all_ratings
    end
  end

  def set_session(title, selected_ratings)
    if title 
      session[:title] = title
    end
    if selected_ratings
      session[:ratings] = selected_ratings
    end
  end

end
