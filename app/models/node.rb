class Node < ActiveRecord::Base
  has_many :edges

  def as_json(options = {})
    super({
      only: [:id, :store_id, :name, :address_line_1, :city, :country, :latitude, :longitude]
    }.merge(options))
  end
end
