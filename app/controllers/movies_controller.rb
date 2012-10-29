class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.scoped
    @all_ratings = ['G','PG','PG-13','R']
    if !params[:ratings] && !params[:order_column]
      session[:ratings] ||= @all_ratings
      redirect_to movies_path( :ratings => session[:ratings], :order_column => session[:order_column] )
    else
      session[:ratings] = params[:ratings] if params[:ratings]
      session[:order_column] = params[:order_column] if params[:order_column]
        if @current_ratings = session[:ratings]
          @movies = @movies.where( :rating => @current_ratings )
        end
        @current_ratings ||= @all_ratings
        @order_column = case session[:order_column]
                        when 'title'
                          'title'
                        when 'release_date'
                          'release_date'
                        else
                          'id'
                        end
        @movies = @movies.order( "#{@order_column} ASC" )
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
