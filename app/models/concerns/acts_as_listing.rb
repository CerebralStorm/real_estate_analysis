module ActsAsListing
  extend ActiveSupport::Concern
  included do
    def self.model_name
      Listing.model_name
    end
  end
end