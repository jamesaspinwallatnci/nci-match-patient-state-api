class P
    include Util
    attr_reader :id
    attr_reader :name
    attr_accessor :description

    attr_reader :net
    attr_accessor :inputs
    attr_accessor :outputs
    attr_reader :internal

    class << self
        def [](name=nil)
            case name
                when Fixnum
                    raise "Error P[#{name}] is out of range." if name < 0 and name > (PNet.default.places.size - 1)
                    places[name]
                when String
                    p = PNet.default.objects[name]
                    raise "Error(P): name not found. #{name} is a #{name.class}" unless p.is_a? P
                    p
                else
                    raise "Error(P): P '#{name}' doesn't exist"
            end
        end

        def places
            PNet.default.places
        end

        def clear
            places.map &:clear
        end


    end

    def initialize(name=nil, options={})
        check_options options, [:net]

        @net = @options[:net] || PNet.default

        @id = P.places.size
        @name= name || "p#{@id}"
        @net.check_duplicate_name(@name)

        @internal = Internal.new
        @inputs = []
        @outputs = []

        @net << self
    end

    def <<(element)
        case element
            when T
                @inputs << element
                element.outputs << self
            when Array
                element.each do |e|
                    case e
                        when T
                            @inputs << e
                            e.outputs << self
                        else
                            raise "Error(P): input should be a T or array of Ts"
                    end
                end
            else
                raise "Error(P): input should be a T or array of Ts"
        end
        element
    end

    def >>(element)
        case element
            when T
                @outputs << element
                element.inputs << self
            when Array
                element.each do |e|
                    case e
                        when T
                            @outputs << e
                            e.inputs << self
                        else
                            raise "Error(P): output should be a T or array of Ts"
                    end
                end
            else
                raise "Error(P): output should be either an a T or array of Ts"
        end
        element
    end

    #P['msg_specimen_received'].set('msg_specimen_received_2'){
    #    @psn = '12345'
    #}
    def set(name, var=nil, value=nil, &proc)


        case var
            when Symbol
                @internal.instance_variable_set(var, value)
            when String
                @internal.instance_variable_set(var, value)
            when Hash
                var.each_pair do |k, v|
                    k='@'+k.to_s
                    @internal.instance_variable_set(k, v)
                end
            when nil
                case proc
                    when Proc
                        @internal.evaluate(proc)
                end

            else
                raise 'Error(P) set #{name} var is neither Hash, nil, String or Symbol'
        end

        processed = {by: name, source: self.class == T ? "Internal" : 'External'}
        Node.create(processed_by: processed, name: @name, at: Time.now.to_f, net: PNet.default.model.to_s, net_id: PNet.default.id, data: @internal.ostruct.to_h)
        PNet.default.state.update_attribute(@name, @internal.ostruct.to_h)
        T.fire

        self
    end

    # P["wait_for_nucleic_acid"].load(data) => {"psn"=>"12345", "processed_by"=>[{"by"=>"T", "name"=>"received_specimen", "at"=>1460757517.93623}]}
    def load(data)
        @internal.clear
        unless data.nil?
            node_data = data.to_hash
            node_data.each_pair do |k, v|
                k='@'+k.to_s
                @internal.instance_variable_set(k, v)
            end
        end
    end

    #P["wait_for_nucleic_acid"].get('psn') => "12345"
    def get(var)
        @internal.instance_variable_get('@'+var)
    end

    # P["wait_for_nucleic_acid"].vars => [:@psn, :@processed_by]
    def vars
        @internal.instance_variables
    end

    def to_h
        @internal.instance_variables_hash
    end

    def to_json
        to_h.to_json
    end

    def inspect
        to_h.inspect
    end

    def empty?
        @internal.empty?
    end

    def not_empty?
        !empty?
    end

    def clear
        @internal.clear
        PNet.default.state.unset(@name)
    end

end

