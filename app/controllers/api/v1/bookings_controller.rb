module Api::V1
  class BookingsController < ApplicationController
    before_action :set_booking, only: [:return] 

    def create
      @booking = Booking.new(booking_params)

      if @booking.save
        render json: @booking, status: :created
      else
        render json: { message: @booking.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def return
      @booking.return!
      render json: @booking, status: :ok
    end

    private

    def set_booking
      @booking = Booking.find(params[:id])
    end

    def booking_params
      params.require(:booking).permit(:user_id, :item_id, :start_date, :end_date)
    end
  end
end
