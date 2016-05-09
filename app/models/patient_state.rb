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
