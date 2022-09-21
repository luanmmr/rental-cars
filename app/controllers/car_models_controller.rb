class CarModelsController < ApplicationController
  before_action :collection_manufacturer,
                :collection_car_category, only: %i[new edit]

  def new
    @car_model = CarModel.new
  end

  def create
    @car_model = CarModel.new(params_car_model)
    return redirect_to cars_path, notice: t('.success') if @car_model.save

    collection_manufacturer
    collection_car_category
    render :new
  end

  def edit
    @car_model = CarModel.find(params[:id])
  end

  def update
    @car_model = CarModel.find(params[:id])
    if @car_model.update(params_car_model)
      flash[:notice] = t('.success')
      redirect_to cars_path
    else
      collection_manufacturer
      collection_car_category
      render :edit
    end
  end

  def destroy
    CarModel.destroy(params[:id])
    redirect_to cars_path, notice: t('.success')
  end

  private

  def params_car_model
    params.require(:car_model).permit(:name, :year, :motorization,
                                      :fuel_type, :car_category_id,
                                      :manufacturer_id)
  end

  def collection_manufacturer
    @manufacturers = Manufacturer.all
  end

  def collection_car_category
    @car_categories = CarCategory.all
  end
end
