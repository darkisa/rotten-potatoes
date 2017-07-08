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

    @selected_ratings = params[:ratings] if params[:ratings]
    @title = params[:title] if params[:title]

    set_session(@title, @selected_ratings)

    if !@selected_ratings || !@title
      @selected_ratings =  get_selected_ratings() unless @selected_ratings
      @title = session[:title] unless @title
      # redirect back to the index with the approproate variables in the params hash
      redirect_to movies_path({ratings: @selected_ratings, title: @title}) 
    end

    @movies = Movie.sort_and_filter(@title, @selected_ratings)
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

  def get_selected_ratings()
    if session[:ratings] then session[:ratings] 
    else @all_ratings.to_a
    end
  end

  def get_title()
    if session[:title] then session[:title]
    else "title"
    end
  end

  def set_session(title, selected_ratings)
    session[:title] = title if title
    session[:ratings] = selected_ratings if selected_ratings
  end

end
