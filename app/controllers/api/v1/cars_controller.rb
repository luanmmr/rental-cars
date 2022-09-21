class Api::V1::CarsController < Api::V1::ApiController
  DEFAULT_KEYS = 3

  def create
    @car = Car.new(car_params)
    render json: @car, status: :created if @car.save!
  rescue ActiveRecord::RecordInvalid
    render json: @car.errors.full_messages, status: :precondition_failed
  end

  def index
    @cars = Car.all
    return render json: @cars, status: :ok unless @cars.empty?

    render json: '', status: :no_content
  end

  def show
    @car = Car.find(params[:id])
    render json: @car, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: '', status: :not_found
  end

  def update
    @car = Car.find(params[:id])
    render json: @car, status: :ok if @car.update!(car_params)
  rescue ActiveRecord::RecordNotFound
    render json: '', status: :not_found
  rescue ArgumentError
    render plain: 'Não houve atualização', status: :precondition_failed
  end

  private

  def car_params
    return unless params.keys.length > DEFAULT_KEYS

    params.permit(:license_plate, :color, :car_model_id, :mileage,
                  :subsidiary_id)
  end
end
