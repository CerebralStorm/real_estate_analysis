class ZipCode < ApplicationRecord
  scope :favorite, -> { where(favorite: true) }
  has_many :listings

  validates :code, presence: true, uniqueness: true, length: {minimum: 5, maximum: 5}
end

