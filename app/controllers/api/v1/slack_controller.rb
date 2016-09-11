module Api::V1
  class SlackController < ApplicationController
    # This controller is responsible for answering
    # to Slack Bot calls

    skip_before_action :authenticate_user

    def parse
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
      when "list_bookings"
        list_bookings split_text
      when "show"
        show split_text
      when "book"
        book split_text
      when "return"
        return_item split_text
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

    def list_bookings split_text
      @bookings = Booking.where(item_id: split_text[1].to_i)
      pp @bookings
      if @bookings.empty?
        render plain: "There are no bookings for this item :pensive:"
      else
        render plain: @bookings.map {|booking| booking.to_s}.join("\n"), parse: "full"
      end
    end

    # Show item
    def show split_text
      @item = Item.find_by_id(split_text[1])
      if @item
        render plain: @item.to_s_show, parse: "full"
      else
        render plain: "Nonexistent item :pensive:"
      end
    end

    # Create booking for an item
    def book split_text 
      #item_id, start_date, end_date
      @item = Item.find_by_id(split_text[1])
      if @item
        user = User.find_by slack_handler: params["user_name"]
        if user
          @booking = Booking.new({"user_id": user.id,
                                  "item_id": split_text[1],
                                  "start_date": split_text[2],
                                  "end_date": split_text[3]})
          if @booking.save
            render plain: "Booking created with success :tada:" 
          else
            puts @booking.errors.inspect
            if @booking.errors.has_key?(:base) && @booking.errors.get(:base).include?("Item is already booked")
              @waiting_queue = WaitingQueue.create(item: @booking.item,
                                                   user: @booking.user)
              #TODO: DIZER EM QUE LUGAR DA WAITING QUEUE FOI COLOCADA
              render plain: "Someone already has that item! You were placed in the waiting queue :woman-woman-girl-girl:" 
            else
              render plain: "Something went wrong, please try again :dizzy_face: :face_with_head_bandage:" 
            end
          end
        else
          render plain: "Sorry, but you need to register an account with your Slack Handler :slack:"
        end
      else
        render plain: "Nonexistent item :x: :package:"
      end
    end

    # Show the user all the possibilities
    def help
      render :plain=> "The commands available are: \n_/stock list_ \n_/stock show <item_id>_ \n_/stock list_bookings <item_id>_ \n_/stock book <item_id> <start_date> <end_date>_ \n_/stock return <item_id>_ \n_/stock help_"
    end

    # Return booked item
    def return_item split_text
      @item = Item.find_by_id(split_text[1])
      @booking = @item&.current_booking
      if @booking
        @booking.return!
        render plain: "Item returned with success :tada:"
      else
        render plain: "You cannot return that item :face_with_head_bandage:"
      end
    end

    # Error parsing the input
    def error
      render :text => ":boom: That option is not available, check /stock help for more information :boom:"
    end
  end
end
