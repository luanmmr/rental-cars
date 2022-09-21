class CarRentalsController < ApplicationController
  def show
    @car_rental = CarRental.find(params[:id])
  end
end
