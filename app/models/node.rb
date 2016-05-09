class Node
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic

    field :net
    field :name
    field :at
    field :net_id
    field :data
end
