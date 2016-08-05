class ZipCode < ApplicationRecord
  scope :favorite, -> { where(favorite: true) }
  has_many :listings

  validates :code, presence: true, uniqueness: true
end

