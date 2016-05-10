class CreatePatientStates < ActiveRecord::Migration
  def change
    create_table :patient_states do |t|
      t.string :message
      t.string :registered
      t.string :msg_patient_registration
      t.string :patient_registration
      t.string :wait_for_specimen
      t.string :msg_specimen_received
      t.string :wait_for_nucleic_acid
      t.string :msg_nucleic_acid_sendout
      t.string :wait_for_variant_report
      t.string :msg_progression
      t.string :msg_off_trial
      t.string :msg_on_treatment_arm
      t.string :msg_treatment_arm_suspended
      t.string :msg_patient_not_eligible
      t.string :msg_specimen_failure
      t.string :msg_pten_ordered
      t.string :msg_pten_result
      t.string :msg_mlh1_ordered
      t.string :msg_mlh1_result
      t.string :msg_msh2_ordered
      t.string :msg_msh2_result
      t.string :msg_rb_ordered
      t.string :msg_rb_result
      t.string :msg_pathology_confirmation
      t.string :output

      t.timestamps null: false
    end
  end
end
