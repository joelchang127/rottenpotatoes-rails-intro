class MoviesController < ApplicationController
  
#   session[:]
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts "helloooooo"
    # when to use session:
    # - no :sort_by + no :rating + params is not empty <-- meaning not base index
    if (!params.has_key?(:rating) && !params.has_key?(:sort_by) && !params.has_key?(:commit))
      puts "ratings_to_show below"
      puts session[:ratings_to_show]
      @ratings_to_show = session[:ratings_to_show]
      @title_header = session[:title_header]
      @release_header = session[:release_header]
      puts "first if statement"
      puts @ratings_to_show
    elsif (params.has_key?(:ratings))
      @ratings_to_show = params[:ratings].keys
      puts "elsif statement"
    else
      @ratings_to_show = Movie.all_ratings
      puts "else statement"
      puts @ratings_to_show.class
    end
    
    if !@ratings_to_show.nil?
      if (params.has_key?(:ratings))
        @ratings_to_show = params[:ratings].keys
      else
        @ratings_to_show = Movie.all_ratings
      end
      @ratings_to_show_sort = @ratings_to_show.map{|rating|[rating,1]}.to_h
    else
      @ratings_to_show_sort = Movie.all_ratings.map{|rating|[rating,1]}.to_h
    end
    
    puts @ratings_to_show_sort.class
    puts @ratings_to_show_sort
    
    @all_ratings = Movie.all_ratings
    @movies = Movie.with_ratings(@ratings_to_show).order(params[:sort_by])
    
    if params[:sort_by] == 'title'
      @title_header = 'hilite mb-2 bg-warning'
    elsif params[:sort_by] == 'release_date'
      @release_header ='hilite mb-2 bg-warning'
    end
    
    if (@title_header == 'hilite mb-2 bg-warning')
      @movies = Movie.with_ratings(@ratings_to_show).order("title")
    elsif (@release_header == 'hilite mb-2 bg-warning')
      @movies = Movie.with_ratings(@ratings_to_show).order("release_date")
    end
    
    
    session[:ratings_to_show] = @ratings_to_show
    session[:title_header] = @title_header
    session[:release_header] = @release_header
    
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
  

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
