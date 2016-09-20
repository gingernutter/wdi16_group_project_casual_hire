class RatingsController < ApplicationController

  def index
    @ratings = Rating.all
    # @rateable = find_rateable
  end

  def show
    @rating = Rating.find( params[:id] )
  end

  def new
    @rating = Rating.new
  end

  def create
    @rateable = find_rateable
    @rating = @rateable.ratings.build(rating_params)
    # @rating = Rating.create( rating_params )
    # redirect_to @rating
  end

  def edit
    @rating = Rating.find params[:id]
  end

  def update
    rating = Rating.find params[:id]
    rating.update( rating_params )
    redirect_to "/ratings/#{rating.id}"
  end

  def destroy
    rating = Rating.find params[:id]
    rating.destroy
    redirect_to "/ratings"
  end

private
  def rating_params
    params.require(:rating).permit(:body, :score, :job_id, :user_id)
  end

  def find_rateable
    @ratings.each do |name, value|
      if name =~ /(.+)_id$/ # Regular Expression
        return $1.classify.constantize.find(value)
      end
    end
  end
end
