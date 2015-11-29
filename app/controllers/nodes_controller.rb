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
    @path = DijkstraService.path(Node.find(start_node_id), Node.find(end_node_id))
  end
end
