module Api::V1
  class SlackController < ApplicationController
    # This controller is responsible for answering
    # to Slack Bot calls

    skip_before_action :authenticate_user

    def parse
      puts "########################"
      puts params.inspect
      puts params.inspect[:token]
      token = params.inspect[:token]
      pp token
      puts "########################"
    end

    private

    # List items
    def list
    end

    # Show item
    def show
    end

    # Create booking for an item
    def book 
    end

    # Return booked item
    def return 
    end
  end
end