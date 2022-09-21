class CarsController < ApplicationController
  before_action :car_model_collection,
                :subsidiary_collection, only: %i[new edit]

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    return redirect_to @car, notice: t('.success') if @car.save

    @car_models = CarModel.all
    @subsidiaries = Subsidiary.all
    render :new
  end

  def index
    @cars = Car.all
    @manufacturers = Manufacturer.all
    @car_models = CarModel.all
  end

  def show
    @car = Car.find(params[:id])
  end

  def edit
    @car = Car.find(params[:id])
  end

  def update
    @car = Car.find(params[:id])
    if @car.update(car_params)
      flash[:notice] = t('.success')
      redirect_to car_path @car
    else
      @car_models = CarModel.all
      @subsidiaries = Subsidiary.all
      render :edit
    end
  end

  def destroy
    Car.destroy(params[:id])
    redirect_to cars_path, notice: t('.success')
  end

  private

  def car_model_collection
    @car_models = CarModel.all
  end

  def subsidiary_collection
    @subsidiaries = Subsidiary.all
  end

  def car_params
    params.require(:car).permit(:license_plate, :color, :mileage, :car_model_id,
                                :subsidiary_id)
  end
end
