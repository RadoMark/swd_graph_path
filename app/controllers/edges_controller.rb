class EdgesController < ApplicationController
  def index

  end

  def destroy
    Edge.find(params["id"]).try(:destroy)

    redirect_to :back
  end

  def manage_edges
    add_edges = params[:add_edges].gsub(" ", "").split(")(").map do |edge_string|
      edge_string.sub("(", "").sub(")", "").split(",").map(&:to_i)
    end
    remove_edges = params[:remove_edges].gsub(" ", "").split(")(").map do |edge_string|
      edge_string.sub("(", "").sub(")", "").split(",").map(&:to_i)
    end

    add_edges.each do |edge_nodes_ids|
      next if edge_nodes_ids.first == edge_nodes_ids.last
      node1 = Node.find(edge_nodes_ids.first)
      node2 = Node.find(edge_nodes_ids.last)
      next if node1.nil? || node2.nil?
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
      next unless edge.nil?
      Edge.create!(
        node1: node1,
        node2: node2,
        distance: response["routes"].first["legs"].first["distance"]["value"],
        time: response["routes"].first["legs"].first["duration"]["value"]
      )
    end

    remove_edges.each do |edge_nodes_ids|
      node1_id = edge_nodes_ids.first
      node2_id = edge_nodes_ids.last
      next if node1_id == node2_id
      edge =
        Edge.where(node1_id: node1_id, node2_id: node2_id).first ||
        Edge.where(node1_id: node2_id, node2_id: node1_id).first
      edge.destroy unless edge.nil?
    end

    redirect_to root_path
  end
end
