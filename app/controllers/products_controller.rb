class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :not_admin?, only: [:create, :destroy]

  # GET /products
  def index
    @products = Product.all.with_attached_image

    render json: @products
  end

  def new
    @product = Product.new
  end

  # POST /products
  def create
      if CreateProductService.new(@product, product_params).call
        render json: @product, status: :created, location: @product
      else
        render json: @product.errors, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.permit(:name, :description, :price, :image, :stock, :category)
    end

    def not_admin?
      @current_user = User.find_by_email(params[:user])
      render json: { message: 'You are unauthorized to add or delete products'}, status: 401 unless @current_user && @current_user.admin
    end
end
