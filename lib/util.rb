@counter = 0

def t(left, right=true, description='Missing message')
    message_size = 100
    description = description[0..message_size-5]+'...' if description.size >75
    puts "#{@counter+=1}) #{description}: #{' ' * (message_size-description.size-@counter.to_s.size)}#{left == right}"
    if not left == right
        raise "ERROR: #{description} #{left} != #{right}"
    end
end

def erby(name)
    tmpl = IO.read(name)
    bind = self.instance_eval('binding')
    ERB.new(tmpl).result(bind)
end

class Array
    alias :old_push :<<

    def <<(e)

        if (self.size>0 and (e.is_a?(T) or e.is_a?(Array)) and self.all? { |n| n.is_a? P }) or
            (self.size>0 and (e.is_a?(P) or e.is_a?(Array)) and self.all? { |n| n.is_a? T })
            self.each do |p|
                p << e
            end
            return e
        else
            old_push(e)
        end
    end

    def >>(e)
        if (self.size>0 and (e.is_a?(T) or e.is_a?(Array)) and self.all? { |n| n.is_a? P }) or
            (self.size>0 and (e.is_a? P or e.is_a?(Array)) and self.all? { |n| n.is_a? T })
            self.each do |p|
                p >> e
            end
            e
        end
    end
end

class Object
    def instance_variables_hash
        Hash[instance_variables.map { |name| [name[1..-1], instance_variable_get(name)] }]
    end
end

module Util
    def check_options(options, options_list)
        @options = options.each_key { |key| options_list.include? key }
        unless @options.empty?
            unless (@options.keys - options_list).empty?
                raise "The following options are incorrect: #{options.keys-options_list}\n Allowed options are: #{options_list}"
            end
        end
    end
end

class OpenStruct
    def clear(name=nil)
        case name
            when nil
                each_pair do |k, v|
                    delete_field(k)
                end
            when String
                delete_field(name)
            when Symbol
                delete_field(name)
            else
                raise "Error(OpenStruct): #{name.inspect} should be nil, String or Symbol"
        end
    end

    def empty?
        to_h.empty?
    end

    def not_empty?
        !empty?
    end
end

class NilClass
    def empty?
        true
    end
    def not_empty?
        false
    end
end