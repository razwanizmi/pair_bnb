class ListingsController < ApplicationController

  before_action :require_login, only: [:edit, :update, :destroy, :create, :new]

  def create
    @listing = Listing.new(listing_params)
    if @listing.save
      redirect_to @listing
    else
      render :new
    end
  end

  def new
    @listing = Listing.new
  end

  def show
    @listing = Listing.find(params[:id])
  end

  def index
    if params[:query].present?
      @listings = Listing.search(params[:query])
    elsif params[:user_id].present?
      @listings = Listing.where(user_id: params[:user_id])
      if User.find(params[:user_id]) == current_user
        @can_add = true
      end
    else
      @listings = Listing.all
      @can_add = true
    end
  end

  def update
    @listing = Listing.find(params[:id])
    byebug
    @listing.update(listing_params)
    if @listing.save
      redirect_to @listing
    else
      render :edit
    end
  end

  def edit
    @listing = Listing.find(params[:id])
    redirect_to @listing if current_user != @listing.user
  end

  def destroy
    @listing = Listing.find(params[:id])
    redirect to listings_path if current_user != @listing.user
    @listing.destroy
    redirect_to listings_path
  end
end

private

def listing_params
  params[:listing][:user_id] = current_user.id
  params.require(:listing).permit(:name, :home_type, :room_type, :accommodates, :address, :city, :price, :user_id, {pictures: []})
end