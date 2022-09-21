class Client < ApplicationRecord
  has_many :rentals, dependent: :destroy

  validates :name, presence: true,
                   format: { with: /\A([a-zA-Z]+|[a-zA-Z]+\s{1}[a-zA-Z]+)\z/ }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: /\A.+@[a-z]+[.]([a-z]+|[a-z]+[.][a-z]+)\z/ }
  validates :document, presence: true, length: { maximum: 11 },
                       numericality: { only_integer: true }, uniqueness: true

  def name_document
    if name.present? && document.present?
      "#{name} - #{document}"
    else
      I18n.t(:incomplete_client, scope:
        %i[activerecord methods client name_document])
    end
  end
end
