module Api::V1
  class WaitingQueuesController < ApplicationController
    # POST /waiting_queue
    def create
      @waiting_queue = WaitingQueue.new(waiting_queue_params)

      if @waiting_queue.save
        render json: @waiting_queue, status: :created
      else
        render json: @waiting_queue.errors, status: :unprocessable_entity
      end
    end

    private

    def waiting_queue_params 
      params.require(:waiting_queue).permit(:user_id, :item_id)
    end
  end
end
