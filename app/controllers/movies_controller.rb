class MoviesController < ApplicationController
  before_action :rented_by_user, only: [:rent]

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
    movie = Movie.find(params[:id])
    movie.available_copies -= 1
    movie.save
    user.rented << movie
    render json: movie
  end

  private
    def rented_by_user
      rented = Rental.where(user_id: params[:user_id], movie_id: params[:id])

      if not rented.nil?
        render :json => {:response => "Movie already rented by user" }, status: :forbidden 
      end
    end
end