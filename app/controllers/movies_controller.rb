class MoviesController < ApplicationController
  
#   session[:]
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

 def index
    
    # when to use session:
    # - no :sort_by + no :rating + params is not empty <-- meaning not base index
#     if (!params.has_key?(:rating) && !params.has_key?(:sort_by) && !params.has_key?(:commit) && params.has_key?(:ratings_to_show) && params.has_key?(:title_header) && params.has_key?(:release_header))
#       @title_header = session[:title_header]
#       @release_header = session[:release_header]
#       @ratings_to_show = session[:ratings_to_show]
#     elsif (params.has_key?(:ratings))
#       @ratings_to_show = params[:ratings].keys
#     else
#       @ratings_to_show = Movie.all_ratings
#     end
   
    # need session if coming from other page
    # 
    
   puts params.inspect
   
    if (!params.has_key?(:ratings) && !params.has_key?(:sort_by) && !params.has_key?(:commit))
      puts "coming from non sort/filter"
      puts "title_header below"
      puts session[:title_header]
      puts "release_header below"
      puts session[:release_header]
      puts "ratings_to_show below"
      puts session[:ratings_to_show]
      @title_header = session[:title_header]
      @release_header = session[:release_header]
      @ratings_to_show = session[:ratings_to_show]
      if @ratings_to_show.nil?
        @ratings_to_show = Movie.all_ratings
      end
      puts "ratings_to_show below pls"
      puts @ratings_to_show
    elsif (params.has_key?(:ratings))
      puts "param has ratings!!"
      @ratings_to_show = params[:ratings].keys
    elsif (!params.has_key?(:ratings))
      puts "no checked boxes!"
      @ratings_to_show = Movie.all_ratings
    end
    
    @all_ratings = Movie.all_ratings
    
    @movies = Movie.with_ratings(@ratings_to_show).order(params[:sort_by])
    
    if params[:sort_by] == 'title'
      @title_header = 'hilite mb-2 bg-warning'
    elsif params[:sort_by] == 'release_date'
      @release_header ='hilite mb-2 bg-warning'
    end
    
    if (@title_header == 'hilite mb-2 bg-warning')
      puts "we should order by title"
      @movies = Movie.with_ratings(@ratings_to_show).order("title")
    elsif (@release_header == 'hilite mb-2 bg-warning')
      puts "we should order by release_date"
      @movies = Movie.with_ratings(@ratings_to_show).order("release_date")
    end
    
    @ratings_to_show_sort = @ratings_to_show.map{|rating|[rating,1]}.to_h
    
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
