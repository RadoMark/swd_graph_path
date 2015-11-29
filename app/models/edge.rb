class Edge < ActiveRecord::Base
  belongs_to :node1, class_name: "Node"
  belongs_to :node2, class_name: "Node"
end
