class ZipCode < ApplicationRecord
  has_many :listings

  validates :code, presence: true, uniqueness: true
end
