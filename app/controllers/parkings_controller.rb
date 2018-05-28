class ParkingsController < ApplicationController
  before_action :authenticate_user!, except: [:parkings_at_location]
  before_action :set_parking, only: [:show, :edit, :update, :destroy]

  layout 'control_panel'

  # GET /parkings
  # GET /parkings.json
  def index
    @parkings = Parking.user_parkings current_user
  end

  # GET /parkings.json
  def parkings_at_location
    render json: MapSquare.new({
                                   radius: params[:radius].to_f,
                                   coord: {
                                       lat: params[:coord][:lat].to_f,
                                       lng: params[:coord][:lng].to_f
                                   }
                               }).parkings_cache
  end

  # GET /parkings/1
  # GET /parkings/1.json
  def show
  end

  # GET /parkings/new
  def new
    @parking = Parking.new
  end

  # GET /parkings/1/edit
  def edit
  end

  # POST /parkings
  # POST /parkings.json
  def create
    @parking = Parking.new(parking_params)

    respond_to do |format|
      if @parking.save
        format.html { redirect_to @parking, notice: t(:parking_created) }
        format.json { render :show, status: :created, location: @parking }
      else
        format.html { render :new }
        format.json { render json: @parking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parkings/1
  # PATCH/PUT /parkings/1.json
  def update
    respond_to do |format|
      if @parking.update(parking_params)
        format.html { redirect_to @parking, notice: t(:parking_updated) }
        format.json { render :show, status: :ok, location: @parking }
      else
        format.html { render :edit }
        format.json { render json: @parking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parkings/1
  # DELETE /parkings/1.json
  def destroy
    @parking.destroy
    respond_to do |format|
      format.html { redirect_to parkings_url, notice: t(:parking_destroyed) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parking
      @parking = Parking.find_for_user(params[:id], current_user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parking_params
      params.require(:parking).permit(:title, :description, :cost, :area, :start_time, :end_time).merge({user: current_user})
    end
end
