class NodesController < ApplicationController
  def index

  end

  def destroy
    node = Node.find(params["id"])
    if node
      Edge.where(node1_id: node.id).destroy_all
      Edge.where(node2_id: node.id).destroy_all
      node.destroy
    end

    redirect_to :back
  end

  def find_path
    start_node_id, end_node_id = params["start_node_id"].to_i, params["end_node_id"].to_i
    waypoint_node_id = params["waypoint_node_id"]
    waypoint_node = waypoint_node_id.blank? ? nil : Node.find(waypoint_node_id.to_i)
    @path =
      DijkstraService.path(
        Node.find(start_node_id),
        Node.find(end_node_id),
        waypoint_node
      )
    @path = {
      nodes_sequence: @path.first.map! { |node_id| Node.find(node_id) },
      distance: @path.last
    }
  end
end
