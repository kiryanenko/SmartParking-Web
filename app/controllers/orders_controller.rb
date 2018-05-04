class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit]
  before_action :set_parking_place, only: [:new, :create]

  layout 'devise'


  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.user_orders current_user
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /parking_places/1/orders/new
  def new
    @order = Order.new
  end


  # POST /parking_places/1/orders
  # POST /parking_places/1/orders.json
  def create
    @order = Order.payment(current_user, @parking_place, order_params[:order_time].to_i, order_params[:payment])

    begin
      respond_to do |format|
        if @order.save
          format.html { redirect_to @order, notice: t(:parking_place_successfully_booked) }
          format.json { render :show, status: :created, location: @order }
        else
          format.html { render :new }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end

    rescue Order::NeedPayment
      respond_to do |format|
        format.html { render :payment }
        format.json { render json: @order.errors, status: :payment_required }
      end
    rescue Order::NotEnoughMoney
      respond_to do |format|
        format.html { render :payment }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    rescue Order::ParkingPlaceNotFree
      respond_to do |format|
        format.html { redirect_to root_path, alert: t(:parking_place_not_free) }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  def set_parking_place
    @parking_place = ParkingPlace.find(params[:parking_place_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:order_time, :payment)
  end
end
