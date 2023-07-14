class MoviesController < ApplicationController
  before_action :is_available, only: [:rent]
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    @movies = Movie.all
    render json: @movies
  end

  def recommendations
    favorite_movies = User.find(params[:user_id]).favorites
    @recommendations = RecommendationEngine.new(favorite_movies).recommendations
    render json: @recommendations
  end

  def user_rented_movies
    @rented = User.find(params[:user_id]).rented
    render json: @rented
  end

  def rent
    user = User.find(params[:user_id])
    @movie.available_copies -= 1
    @movie.save
    user.rented << @movie
    render json: @movie
  end

  private
   def is_available
      @movie = Movie.find(params[:id])
      if @movie.available_copies == 0
        render :json => {:response => 'The selected movie cannot be rented as it is unavailable.' }, status: :forbidden
      end
    end
       
    def not_found
      render :json => {:response => "Resource not found"}, status: :not_found
    end

    def show
      movie = Movie.find(params[:id])
      render json: movie
    end
end