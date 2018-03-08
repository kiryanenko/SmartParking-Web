class ParkingPlacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parking_place, only: [:show, :edit, :update, :destroy]
  before_action :set_parking, only: [:new, :create]

  layout 'control_panel'

  # GET /parking_places
  # GET /parking_places.json
  # def index
  #   @parking_places = ParkingPlace.all
  # end

  # GET /parking_places/1
  # GET /parking_places/1.json
  def show
  end

  # GET /parking_places/new
  def new
    @parking_place = ParkingPlace.new
  end

  # GET /parking_places/1/edit
  def edit
  end

  # POST /parking_places
  # POST /parking_places.json
  def create
    @parking_place = ParkingPlace.new(parking_place_params.merge(parking: @parking))

    respond_to do |format|
      if @parking_place.save
        format.html { redirect_to @parking_place, notice: t(:parking_place_created) }
        format.json { render :show, status: :created, location: @parking_place }
      else
        format.html { render :new }
        format.json { render json: @parking_place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parking_places/1
  # PATCH/PUT /parking_places/1.json
  def update
    respond_to do |format|
      if @parking_place.update(parking_place_params)
        format.html { redirect_to @parking_place, notice: t(:parking_place_updated) }
        format.json { render :show, status: :ok, location: @parking_place }
      else
        format.html { render :edit }
        format.json { render json: @parking_place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parking_places/1
  # DELETE /parking_places/1.json
  def destroy
    @parking_place.destroy
    respond_to do |format|
      format.html { redirect_to parking_places_url, notice: t(:parking_place_destroyed) }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_parking_place
    @parking_place = ParkingPlace.find_for_user(params[:id], current_user)
  end

  def set_parking
    @parking = Parking.find_for_user(params[:parking_id], current_user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def parking_place_params
    params.require(:parking_place).permit(:place_id, :sensor_id, :title, :coord, :for_disabled, :can_book)
  end
end
