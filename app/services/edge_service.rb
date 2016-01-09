class EdgeService
  def self.create(node1, node2)
    edge =
      Edge.where(node1_id: node1.id, node2_id: node2.id).first ||
      Edge.where(node1_id: node2.id, node2_id: node1.id).first

    response = RestClient.get(
      "https://maps.googleapis.com/maps/api/directions/json",
      params: {
        origin: "#{node1.latitude},#{node1.longitude}",
        destination: "#{node2.latitude},#{node2.longitude}"
      }
    )
    response = JSON.parse(response)
    return unless edge.nil?
    begin
      sleep(1.5)
      Edge.create!(
        node1: node1,
        node2: node2,
        distance: response["routes"].first["legs"].first["distance"]["value"],
        time: response["routes"].first["legs"].first["duration"]["value"]
      )
    rescue StandardError => e
      Rails.logger.error e.message
    end
  end
end
