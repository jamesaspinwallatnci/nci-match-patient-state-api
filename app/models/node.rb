if Rails.env == 'production'
    class Node
        include Mongoid::Document
        include Mongoid::Attributes::Dynamic

        field :net
        field :name
        field :at
        field :net_id
        field :data
    end
else
    class Node < ActiveRecord::Base
        serialize :data
        serialize :processed
    end
end
