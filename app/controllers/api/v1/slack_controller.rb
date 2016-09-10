module Api::V1
  class SlackController < ApplicationController
    # This controller is responsible for answering
    # to Slack Bot calls

    skip_before_action :authenticate_user

    def parse
      #client = Slack::Web::Client.new
      #client.auth_test

      token = params["token"].inspect
      slack_handler = params["user_name"].inspect
      text = params["text"].inspect

      parse_text text
    end

    private

    #Parse the text after /stock
    def parse_text text

      #remove escape characters and split the string into an array
      text = text.tr!('"', '')
      split_text = text.split(" ")

      #TODO: há proteções que precisam de ser feitas quando actuo consoante o parse do input 
      case split_text[0]
      when "list"
        list
      when "show"
        show split_text
      when "book"
        book split_text
      when "help"
        help
      else
        error
      end
    end

    # List items
    def list
      @items = Item.all
      render plain: @items.map {|item| item.to_s_list}.join("\n")
    end

    # Show item
    def show split_text
      @item = Item.find_by_id(split_text[1])
      if @item
        render plain: @item.to_s_show
      else
        render plain: "Nonexistent item"
      end
    end

    # Create booking for an item
    def book split_text 
      #item_id, start_date, end_date
      @item = Item.find_by_id(split_text[1])
      if @item
        begin
          user = User.find_by params["slack_handler"]
        rescue ActiveRecord::RecordNotFound => e
          user = nil
        end

        if user
          pp split_text[2]
          @booking = Booking.new({"user_id": user.id,
                                  "item_id": split_text[2],
                                  "start_date": split_text[3],
                                  "end_date": split_text[4]})
          if @booking.save
            render plain: "Booking created with success" 
          else
            if @booking.errors.has_key?(:item_already_booked)
              @waiting_queue = WaitingQueue.create(item: @booking.item,
                                                   user: @booking.user)
              #TODO: DIZER EM QUE LUGAR DA WAITING QUEUE FOI COLOCADA
              render plain: "Someone already has that item! You were placed in the waiting queue!" 
            else
              render plain: "Something went wrong, please try again! Sorry!" 
            end
          end
        else
          render plain: "Sorry, but you need to register an account with your Slack Handler"
        end
      else
        render plain: "Nonexistent item"
      end
    end

    # Show the user all the possibilities
    def help
      render :text => "dar render de todas a instruções possíveis"
    end

    # Return booked item
    def return 
    end

    # Error parsing the input
    def error
      render :text => "error"
    end
  end
end
