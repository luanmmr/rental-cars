class Rental < ApplicationRecord
  belongs_to :client
  belongs_to :car_category
  belongs_to :user
  has_one :car_rental, dependent: :restrict_with_exception

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :valid_start_date, :valid_end_date
  validate :availables_cars, on: %i[create save]

  enum status: { scheduled: 0, in_progress: 1, expired: 2, canceled: 3 }

  def able_to_cancel?
    Time.zone.today < (start_date - 1.day)
  end

  def daily_price_total
    if car_category.present?
      car_category.daily_rate + car_category.car_insurance +
        car_category.third_party_insurance
    else
      I18n.t(:incomplete_rental, scope:
        %i[activerecord methods rental daily_price_total])
    end
  end

  def car_insurance
    if car_category.present?
      car_category.car_insurance
    else
      I18n.t(:incomplete_rental, scope:
        %i[activerecord methods rental daily_price_total])
    end
  end

  def third_party_insurance
    if car_category.present?
      car_category.third_party_insurance
    else
      I18n.t(:incomplete_rental, scope:
        %i[activerecord methods rental daily_price_total])
    end
  end

  def rental_expired?
    if start_date < Time.zone.today && scheduled?
      errors.add(:base, I18n.t(:expired_rental, scope:
        %i[activerecord methods rental expired?]))
      true
    else
      false
    end
  end

  private

  def valid_start_date
    return unless start_date && start_date < Time.zone.today

    message = I18n.t(:invalid_start_date, scope:
                %i[activerecord methods rental valid_start_date])
    errors.add(:start_date, message)
  end

  def valid_end_date
    return unless end_date && end_date < start_date

    message = I18n.t(:invalid_end_date, scope:
                %i[activerecord methods rental valid_end_date])
    errors.add(:end_date, message)
  end

  def availables_cars
    if car_category && car_category.car_models.present?
      message = I18n.t(:no_car, scope:
                  %i[activerecord methods rental availables_cars])
      errors[:base] << message if rented_cars.length >= category_cars.length
    else
      I18n.t(:incomplete_rental, scope:
        %i[activerecord methods rental availables_cars])
    end
  end

  def rented_cars
    car_category_rentals.where(start_date: start_date..end_date)
                        .or(car_category_rentals
                        .where(end_date: start_date..end_date))
                        .or(start_date_before_and_end_date_after)
  end

  def car_category_rentals
    scheduled = 0
    in_progress = 1
    Rental.where(car_category: car_category, status: scheduled..in_progress)
  end

  def category_cars
    Car.where(car_model: car_category.car_models)
  end

  def start_date_before_and_end_date_after
    car_category_rentals.where('start_date < ? AND end_date > ?',
                               start_date.to_s, end_date.to_s)
  end
end
