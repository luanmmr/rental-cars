class Api::V1::RentalsController < Api::V1::ApiController
  def create
    @rental = Rental.new(rental_params)
    render json: @rental, status: :ok if @rental.save!
  rescue ActiveRecord::RecordInvalid
    render json: @rental.errors.full_messages, status: :precondition_failed
  end

  def client_rentals
    @client = Client.find_by!(document: params[:id])
    @rentals = Rental.where(client: @client)
    unless @rentals.empty?
      return render json: @rentals.as_json(include: { client:
        { only: %i[name document] }, car_category: { only: :name } }, except:
        %i[client_id car_category_id]), status: :ok
    end
    render json: '', status: :no_content
  rescue ActiveRecord::RecordNotFound
    render json: '', status: :not_found
  end

  def show
    @rental = Rental.find(params[:id])
    render json: @rental.as_json(include: { client:
      { only: %i[name document] }, car_category: { only: :name } }, except:
      %i[client_id car_category_id]), status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: '', status: :not_found
  end

  private

  def rental_params
    params.permit(:code, :start_date, :end_date, :client_id, :car_category_id,
                  :user_id)
  end
end
