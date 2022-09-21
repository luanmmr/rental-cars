class ManufacturersController < ApplicationController
  def new
    @manufacturer = Manufacturer.new
  end

  def create
    @manufacturer = Manufacturer.new(manufacturer_params)
    return redirect_to cars_path, notice: t('.success') if @manufacturer.save

    render :new
  end

  def edit
    @manufacturer = Manufacturer.find(params[:id])
  end

  def update
    @manufacturer = Manufacturer.find(params[:id])
    if @manufacturer.update(manufacturer_params)
      flash[:notice] = t('.success')
      redirect_to cars_path
    else
      render :edit
    end
  end

  def destroy
    Manufacturer.destroy(params[:id])
    redirect_to cars_path, notice: t('.success')
  end

  private

  def manufacturer_params
    params.require(:manufacturer).permit(:name)
  end
end
