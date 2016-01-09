class Edge < ActiveRecord::Base
  belongs_to :node1, class_name: "Node"
  belongs_to :node2, class_name: "Node"

  def as_json(options = {})
    super(only: [:id, :distance, :time]).merge({
        node1: node1,
        node2: node2
      })
  end
end
