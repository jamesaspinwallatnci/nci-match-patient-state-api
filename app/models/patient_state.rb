if Rails.env == 'production'
    class PatientState
        #include Mongoid::Document
        #include Mongoid::Attributes::Dynamic

        include Dynamoid::Document

        field :message, :serialized

        field :registered, :serialized
        field :msg_patient_registration, :serialized
        field :patient_registration, :serialized
        field :wait_for_specimen, :serialized
        field :msg_specimen_received, :serialized
        field :wait_for_nucleic_acid, :serialized
        field :msg_nucleic_acid_sendout, :serialized
        field :wait_for_variant_report, :serialized

        field :msg_progression, :serialized
        field :msg_off_trial, :serialized
        field :msg_on_treatment_arm, :serialized
        field :msg_treatment_arm_suspended, :serialized
        field :msg_patient_not_eligible, :serialized
        field :msg_specimen_failure, :serialized
        field :msg_pten_ordered, :serialized
        field :msg_pten_result, :serialized
        field :msg_mlh1_ordered, :serialized
        field :msg_mlh1_result, :serialized
        field :msg_msh2_ordered, :serialized
        field :msg_msh2_result, :serialized
        field :msg_rb_ordered, :serialized
        field :msg_rb_result, :serialized
        field :msg_pathology_confirmation, :serialized

        field :output, :serialized

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

        serialize :message, JSON
        serialize :registered, JSON
        serialize :msg_patient_registration, JSON
        serialize :patient_registration, JSON
        serialize :wait_for_specimen, JSON
        serialize :msg_specimen_received, JSON
        serialize :wait_for_nucleic_acid, JSON
        serialize :msg_nucleic_acid_sendout, JSON
        serialize :wait_for_variant_report, JSON
        serialize :msg_progression, JSON
        serialize :msg_off_trial, JSON
        serialize :msg_on_treatment_arm, JSON
        serialize :msg_treatment_arm_suspended, JSON
        serialize :msg_patient_not_eligible, JSON
        serialize :msg_specimen_failure, JSON
        serialize :msg_pten_ordered, JSON
        serialize :msg_pten_result, JSON
        serialize :msg_mlh1_ordered, JSON
        serialize :msg_mlh1_result, JSON
        serialize :msg_msh2_ordered, JSON
        serialize :msg_msh2_result, JSON
        serialize :msg_rb_ordered, JSON
        serialize :msg_rb_result, JSON
        serialize :msg_pathology_confirmation, JSON
        serialize :output, JSON

        def unset(name)
            self[name] = nil
            self.save
        end
    end

end
