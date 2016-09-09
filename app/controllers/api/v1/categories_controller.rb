module Api::V1
  class CategoriesController < ApplicationController
    before_action :set_category, only: [:show, :update, :destroy] 

    # GET /categories
    def index
      @categories = Category.all

      render json: @categories
    end

    # GET /categories/1
    def show
      render json: @category
    end

    # POST /categories
    def create
      @category = Category.new(category_params)

      if @category.save
        render json: @category, status: :created, location: v1_item_path(@category)
      else
        render json: @category.erros, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /categories/1
    def update
      if @category.update(category_params)
        render json: @category
      else
        render json: @category.errors, status: :unprocessable_entity
      end
    end

    #DELETE /categories/1
    def destroy
      if @category.destroy
        render json: @item, status: :deleted
      else
        render json: @item.errors, status: :conflict
      end
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
