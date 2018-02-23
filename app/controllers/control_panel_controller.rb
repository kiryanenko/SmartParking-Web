class ControlPanelController < ApplicationController
  layout 'control_panel'
  before_action :authenticate_user!

  def main
    render 'control_panel/main'
  end
end
