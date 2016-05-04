class T
    include Util
    attr_reader :id, :name, :net
    attr_accessor :description, :inputs, :outputs, :guard

    class << self
        def [](name=nil, &block)
            case name
                when Fixnum
                    t = transitions[name]
                when String
                    t = PNet.default.objects[name]
                    raise "Error(P): name not found. #{name} is a #{name.class}" unless t.is_a? T
                    t
                else
                    raise "Error(T): T[#{name}] doesn't exist"
            end
            t.guard = block unless block.nil?
            t
        end

        def transitions
            PNet.default.transitions
        end

        def fire
            until (firables = T.transitions.select(&:is_firable?)).empty?
                firables.map &:exec
            end
        end
    end

    def initialize(name=nil, &block)
        @net = PNet.default
        @id = T.transitions.size
        @name= name.nil? ? "t#{T.transitions.size}" : name
        @net.check_duplicate_name(@name)

        @internal = Internal.new
        @inputs = []
        @outputs = []
        @guard = block unless block.nil?

        @net << self
    end

    def execute(&block)
        @execute=block
        self
    end

    def <<(element)
        case element
            when P
                @inputs << element
                element.outputs << self
            when Array
                element.each do |e|
                    case e
                        when P
                            @inputs << e
                            e.outputs << self
                        else
                            raise "Error(T): input should be a P or array of Ps"
                    end
                end
            else
                raise "Error(T): input should be a P or array of Ps"
        end
        element
    end

    def >>(element)
        case element
            when P
                @outputs << element
                element.inputs << self
            when Array
                element.each do |e|
                    case e
                        when P
                            @outputs << e
                            e.inputs << self
                        else
                            raise "Error(T): output should be a P or array of Ps"
                    end
                end
            else
                raise "Error(T): output should be a P or array of Ps"
        end
        element
    end

    def is_firable?
        (@inputs+@outputs).each do |p|
            @internal.instance_variable_set('@'+p.name, p.internal.ostruct)
        end
        @internal.evaluate(@guard)
    end

    def exec
        #@outputs.each do |p|
        #    @internal.instance_variable_set('@'+p.name, p.internal.ostruct)
        #end

        @internal.evaluate(@execute)

        (@inputs+@outputs).each do |p|
            ostruct = @internal.instance_variable_get('@'+p.name)

            processed = {by: @name, source: self.class == T ? "Internal" : 'External', }
            Node.create(processed: processed, name: p.name, at: Time.now.to_f, net: PNet.default.model.to_s, net_id: PNet.default.id, data: ostruct.to_h)
            p.internal.instance_variables.each do |name|
                p.internal.remove_instance_variable(name)
            end

            ostruct.each_pair do |k, v|
                name = '@'+k.to_s
                p.internal.instance_variable_set(name, v)
            end

            if ostruct.to_h == {}
                PNet.default.state.unset(p.name)
            else
                PNet.default.state.update_attribute(p.name, ostruct.to_h)
            end
        end
    end

    def clear
        @internal.clear
    end

    def remove_input_states
        @inputs.map &:clear
    end

    def remove_output_states
        @outputs.map &:clear
    end

    def to_h
        {name: name, inputs: @inputs.map(&:to_h), outputs: @outputs.map(&:to_h)}
    end

    def inspect
        self.to_h.inspect
    end
end

