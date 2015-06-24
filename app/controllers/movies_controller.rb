  class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    
    # Trata a variável de ordenação da lista  
    if params[:sort_by].nil? and !session[:sort_by].nil?
      @sort_by = session[:sort_by] 
      redirect = true
    else
      @sort_by = params[:sort_by]
    end
    session[:sort_by] = @sort_by
    
    # Trata a variável de filtro da lista
    @all_ratings = Movie.all_ratings
    if params[:ratings].nil? and !session[:ratings].nil?
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = params[:ratings]
    end
    session[:ratings] = @ratings
    
    if @ratings
      # Recupera a lista de filmes de acordo com o filtro
      @movies = Movie.where(rating: @ratings.keys) 
      # Aplica ordenação de acordo com a opção do usuário
      @movies = @movies.find(:all, :order => (@sort_by)) if @sort_by
    else
      # Recupera a lista completa de filmes
      @movies = Movie.find(:all, :order => (params[:sort]))
    end
    
    # Caso não exista nenhum valor para o filtro, então são marcadas todas as opções
    if params[:ratings].nil? and session[:ratings].nil?
      @ratings = Hash.new
      @all_ratings.each do |value|
        @ratings[value] = value
      end
    end
    
    if redirect
      flash.keep
      redirect_to movies_path({:sort_by => @sort_by, :ratings => @ratings})
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
