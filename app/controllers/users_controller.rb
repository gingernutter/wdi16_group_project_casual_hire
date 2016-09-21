class UsersController < ApplicationController
  before_action :authorise, :only => [:index, :show, :edit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    # This is the magic stuff that will let us upload an image to Cloudinary when creating a new user.
    # First, check to see if the user has attached an image for uploading
    if params[:file].present?
      # Then call Cloudinary's upload method, passing in the file in params
      req = Cloudinary::Uploader.upload(params[:file])
    # Using the public_id allows us to use Cloudinary's powerful image transformation methods.
    user.image = req["public_id"]
    user.save
    redirect_to user_path(user)
  end

    @user = User.new(user_params)
    @user = User.create(user_params)

    # respond_to do |format|
    #   if @user.save
    #     # format.html { redirect_to @user, notice: 'User was successfully created.' }
    #     format.json { render :show, status: :created, location: @user }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    user = User.find params[:id]
    user.update(user_params)

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    user = User.find params[:id]
    user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def rate
    @rating = Rating.new(rating_params)
    @rating.job_id = params[:job_id]

    if params[:user_id].to_i == @current_user.id
      render :json => { :moron => "You" }
      return
    end

    User.find_by(:id => params[:rating][:user_id]).ratings << @rating

      if @rating.save
        render json: @rating
      else
        render json: @rating.errors, status: :unprocessable_entity
      end
  
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin, :role, :job_id, :comment_id, :applicant_id, :rating_id)
  end

  def rating_params
    params.require(:rating).permit(:body, :score, :job_id, :user_id)
  end

  def authorise
    flash[:error] = "You need to be logged in to see that" unless @current_user.present?

    redirect_to login_path unless @current_user.present?
  end
end
