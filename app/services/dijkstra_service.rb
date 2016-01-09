class DijkstraService
  def self.path(node1, node2, nodeWaypoint = nil)
    return if node1.nil? || node2.nil?
    start, stop = node1.id, node2.id
    if nodeWaypoint.nil?
      graph.shortest_path(start, stop)
    else
      waypoint = nodeWaypoint.id
      first_path = graph.shortest_path(start, waypoint)
      last_path = graph.shortest_path(waypoint, stop)
      distance = first_path.last + last_path.last
      first_path.first.pop
      path = (first_path.first + last_path.first).flatten
      [path, distance]
    end
  end

  def self.graph
    @graph ||= Graph.new(
      Edge.includes(:node1, :node2).all.map do |edge|
        [edge.node1.id, edge.node2.id, edge.distance]
      end
    )
  end
end
