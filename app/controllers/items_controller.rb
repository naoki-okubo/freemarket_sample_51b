class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.all.order("id DESC").limit(4)
  end

  def new
    @item = Item.new
    @item.items_categories.build
  end

  def create
    @item = Item.new(item_params)
    @status = '出品中'
    if @item.save
      redirect_to item_path(@item)
    else
      redirect_to new_item_path,notice: '入力されていない項目があります'
    end
  end

  def destroy
    if @item.user_id == current_user.id
      @item.destroy
      redirect_to root_path
    end
  end

  def show
    @images = @item.images
    @goods = Like.where(status: "良い")
    @normals = Like.where(status: "普通")
    @bads = Like.where(status: "悪い")
    @category = @item.categories.first
  end

  def edit
    @item = Item.find(params[:id])
    @serect_category = @item.categories.first
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    end
  end


  private

  def item_params
    params.require(:item).permit(:name, :discription, :item_condition, :delivery_fee, :shipping_rule, :prefecture_id, :shipping_date, :price,images:[],brand_attributes: [:id, :name], items_categories_attributes: [:id,:category_id]).merge(user_id: current_user.id, status: @status)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
