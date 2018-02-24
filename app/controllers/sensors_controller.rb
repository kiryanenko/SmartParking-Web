class SensorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sensor, only: [:show, :edit, :update, :destroy]

  layout 'control_panel'


  # GET /sensors
  # GET /sensors.json
  def index
    @sensors = Sensor.user_sensors current_user
  end

  # GET /sensors/1
  # GET /sensors/1.json
  # def show
  # end

  # GET /sensors/new
  # def new
  #   @sensor = Sensor.new
  # end

  # GET /sensors/1/edit
  def edit
  end

  # POST /sensors
  # POST /sensors.json
  def create
    @sensor = Sensor.new(user: current_user)

    respond_to do |format|
      if @sensor.save
        format.html { redirect_to sensors_path, notice: t(:sensor_created) }
        format.json { render :show, status: :created, location: @sensor }
      else
        format.html { render :new }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sensors/1
  # PATCH/PUT /sensors/1.json
  def update
    respond_to do |format|
      params = sensor_params
      params[:day_start_time] = parse_time params[:day_start_time] { @sensor.errors.add :day_start_time, t(:invalid_time) }
      params[:night_start_time] = parse_time params[:night_start_time] { @sensor.errors.add :night_start_time, t(:invalid_time) }
      if @sensor.errors.empty? and @sensor.update(params)
        format.html { redirect_to sensors_path, notice: t(:sensor_updated) }
        format.json { render :show, status: :ok, location: @sensor }
      else
        format.html { render :edit }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sensors/1
  # DELETE /sensors/1.json
  def destroy
    @sensor.destroy
    respond_to do |format|
      format.html { redirect_to sensors_url, notice: 'Sensor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sensor
      @sensor = Sensor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sensor_params
      params.require(:sensor).permit(:sampling_period, :sending_period, :day_cast, :night_cast, :day_start_time, :night_start_time)
    end

    def parse_time(time_str)
      begin
        time = Time.parse(time_str)
        time.hour * 3600 + time.min * 60 + time.sec
      rescue
        yield
      end
    end
end
