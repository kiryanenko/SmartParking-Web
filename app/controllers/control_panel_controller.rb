class ControlPanelController < ApplicationController
  layout 'control_panel'
  before_action :authenticate_user!

  def main
  end

  def orders
    @orders = Order.owner_orders current_user
  end
end
