class RentalsController < ApplicationController
  before_action :clients_collection, :categories_collection, only: %i[new edit]

  def new
    @rental = Rental.new
  end

  def create
    @rental = Rental.new(params_rental)
    @rental.code = SecureRandom.hex(5)
    @rental.user = current_user

    return redirect_to @rental, notice: t('.success') if @rental.save

    clients_collection
    categories_collection
    render :new
  end

  def index
    @rentals = Rental.order(status: :asc)
  end

  def show
    @rental = Rental.find(params[:id])
    if @rental.scheduled? && @rental.rental_expired?
      flash.now[:alert] = t('.expired')
      @rental.expired!
      @valid = false
    else
      @valid = true
    end
  end

  def search
    # Busca exata
    # @rentals = Rental.where(code: params[:q])
    # Outro modo de busca exata, agora, utilizando SQL
    # @rentals = Rental.where("code LIKE ?", "#{params[:q]}")
    @q = params[:q]
    @rentals = Rental.where('code LIKE ?', "%#{params[:q]}%")
  end

  def book
    @rental = Rental.find(params[:id])
    @car_rental = CarRental.new
    @cars = Car.where(car_model: @rental.car_category.car_models)
  end

  def create_book
    @rental = Rental.find(params[:id])
    @car = Car.find(params[:car_rental][:car_id])
    @car_rental = CarRental.new(car_rental_parameters)
    redirect_to @car_rental, notice: t('.success') if @car_rental.save!
  end

  def cancel
    @rental = Rental.find(params[:id])
    unless @rental.able_to_cancel?
      return redirect_to @rental, alert: I18n.t(:cannot_cancel, scope:
        %i[activerecord methods cancel_rental])
    end
    @cancel_rental = CancelRental.new
  end

  def cancellation_confirmation
    @rental = Rental.find(params[:id])
    @cancel_rental = CancelRental.new(rental: @rental,
                                      reason: params[:cancel_rental][:reason])
    if @cancel_rental.save
      flash[:notice] = t('.success')
      redirect_to rentals_path
    else
      render :cancel
    end
  end

  private

  def car_rental_parameters
    {
      car: @car, rental: @rental, daily_price: @rental.daily_price_total,
      car_insurance: @rental.car_insurance, start_mileage: @car.mileage,
      third_party_insurance: @rental.third_party_insurance,
      end_mileage: @car.mileage
    }
  end

  def clients_collection
    @clients = Client.all
  end

  def categories_collection
    @car_categories = CarCategory.all
  end

  def params_rental
    params.require(:rental).permit(:start_date, :end_date, :client_id,
                                   :car_category_id)
  end
end
