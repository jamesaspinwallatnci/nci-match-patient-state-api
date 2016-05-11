if Rails.env == 'production'

    class PatientState
        include Dynamoid::Document

        $states.each do |state|
            field state, :serialized
        end

        class << self
            def destroy_all
                self.all.each &:detroy
            end

            def delete_all
                self.all.each &:delete
            end
        end

        def unset(name)
            self[name] = nil
            self.save
        end
    end
else

    class PatientState < ActiveRecord::Base

        def unset(name)
            self[name] = nil
            self.save
        end
    end
end
