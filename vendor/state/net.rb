class PNet

    attr_accessor :name, :places, :transitions, :objects, :firable_transitions, :id, :state, :model

    @@petris = []
    @@default=nil
    class << self
        def petris
            @@petris
        end

        def default
            @@default
        end

        def [](name)
            #raise 'Error(PNet) n > Number of PetriNets' unless n < @@petris.size and n >=0
            index = @@petris.index { |petri|
                petri.name == name
            }
            index.nil? ? nil : @@petris[index]
        end
    end

    def initialize(model)

        @id = id
        @model = model

        @objects = {}
        @places = []
        @transitions = []
        @firable_transitions = []

        @@petris << self
        @@default = self
    end

    def [](name)
        object = @objects[name]
        raise "Error: retrieving an invalid object named #{name}" if object.nil?
        object
    end

    def <<(object)

        #check_duplicate_name(object.name)
        case object
            when P
                @places << object
                @objects[object.name] = object
            when T
                @transitions << object
                @objects[object.name] = object
            when A
                @arcs << object
                @objects[object.name] = object
            else
                raise "Unknown object #{object.class}."
        end
    end

    def names
        @objects.keys
    end

    def check_duplicate_name(object_name)
        raise "Error: duplicate name: #{object_name}" if @objects.key?(object_name)
    end

    def append_firable(transition)
        @firable_transitions << transition if transition.is_a? T
    end

    def load(id)
        @id = id
        @state = model.find(id)

        unless @state.nil?
            PNet.default.places.each do |p|
                p.load(@state[p.name])
            end
        else
            @state = model.create(id: id)
            PNet.default.places.each do |p|
                p.load(nil)
            end
            PNet.default.places.map { |x| x.internal.to_h }
        end
    end

    def delete_all
        @model.delete_all
        # TODO: delete only Nodes where net: @model
        Node.delete_all
    end

end
