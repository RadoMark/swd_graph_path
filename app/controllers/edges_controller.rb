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
      EdgeService.create(node1, node2)
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

  def generate_edges
    city_nodes = Node.all.group_by { |n| n.city }
    city_nodes["Wroclaw"] += city_nodes.delete("Bielany Wroclawskie")
    city_nodes["Warszawa"] += city_nodes.delete("Warsaw")
    city_nodes.each do |city, nodes|
      nodes.each do |node1|
        nodes.each do |node2|
          EdgeService.create(node1, node2) if node1.id != node2.id
        end
      end
    end

    main_city_nodes = city_nodes.map { |city, nodes| nodes.first }
    main_city_nodes.each do |node1|
      main_city_nodes.each do |node2|
        EdgeService.create(node1, node2) if node1.id != node2.id
      end
    end

    redirect_to root_path
  end
end
