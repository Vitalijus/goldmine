class PagesController < ApplicationController
  def home
  end

  def download
    payment_id = params[:id]
    @payment = Payment.find_by(id: payment_id)
  end
end
