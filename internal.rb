class Internal
    def get_binding
        binding
    end

    def evaluate(code)
        case code
            when String
                eval(code, self.get_binding)
            when Proc
                ret = nil
                instance_eval(&code)
            else
                raise "Error Internal#evaluate is not String or Proc"
        end
    end

    def vars
        instance_variables.map { |x| "#{x.to_s}=#{evaluate(x.to_s)}" }.join('; ')
    end

    def import(array)
        text = array.map(&:vars).join('; ')
        evaluate(text)
        self
    end

    def ostruct
        open_struct = OpenStruct.new
        instance_variables.each { |v|
            name = v.to_s[1..-1]+'='
            open_struct.send(name, instance_variable_get(v))
        }
        open_struct
    end

    def clear
        instance_variables.each do |var|
            remove_instance_variable(var)
        end
    end

    def empty?
        instance_variables.size == 0
    end

    def ts
        (Time.now.to_f*10**5).to_i
    end

    def to_h
        hash = {}
        instance_variables.each { |v|
            hash[v]=instance_variable_get(v)
        }
        hash
    end
end
