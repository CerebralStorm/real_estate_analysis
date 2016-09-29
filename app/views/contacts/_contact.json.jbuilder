json.extract! contact, :id, :name, :phone_number, :address, :company, :profession, :email, :created_at, :updated_at
json.url contact_url(contact, format: :json)