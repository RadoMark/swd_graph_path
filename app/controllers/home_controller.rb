class HomeController < ApplicationController
  def index

  end

  def upload
    Edge.destroy_all
    Node.destroy_all
    file = SmarterCSV.process(params["file"].path)
    file.each do |row|
      next if Node.find_by(store_id: row[:store_id])
      create_hash = row.slice(
        :store_id,
        :name,
        :address_line_1,
        :address_line_2,
        :postal_code,
        :city,
        :country,
        :latitude,
        :longitude
      )

      create_hash[:address_line_1] = row[:street_combined]
      Node.create!(create_hash.merge(additional_info: YAML.dump(row)))
    end
    redirect_to root_path
  end
end
