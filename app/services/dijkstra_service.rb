class DijkstraService
  def self.path(node1, node2, nodeTransit = nil)
    return if node1.nil? || node2.nil?
    start, stop = node1.id, node2.id
    graph.shortest_path(start, stop)
  end

  def self.graph
    @graph ||= Graph.new(
      Edge.includes(:node1, :node2).all.map do |edge|
        [edge.node1.id, edge.node2.id, edge.distance]
      end
    )
  end
end
