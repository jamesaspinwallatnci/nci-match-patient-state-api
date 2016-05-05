load 'init.rb'

Net.new("Test if patient registration.")

P.new('patient_registration')
P.new('wait_for_specimen')
P.new('msg_specimen_received')
P.new('rejected_message_patient_registration')
P.new('wait_for_nucleic_acid')
P.new('msg_nucleic_acid_sendout')
P.new('wait_for_variant_report')

T.new('received_new_patient_registration_message') {
    Patient.find_by(psn: @patient_registration.psn).nil? and @patient_registration.done.nil?
}.execute {
    @patient_registration.done = true
    @wait_for_specimen.created_at = Time.now.strftime("%H:%M:%S")
    @wait_for_specimen.psn = @patient_registration.psn

    Patient.create(psn: @patient_registration.psn)
}

T.new('received_existing_patient_registration_message') {
    not Patient.find_by(psn: @patient_registration.psn).nil? and @patient_registration.done.nil?
}.execute {
    @patient_registration.done = true
    @rejected_message_patient_registration.created_at = Time.now.strftime("%H:%M:%S")
    @rejected_message_patient_registration.psn = @patient_registration.psn
}

P['patient_registration'] >> T['received_new_patient_registration_message'] >> P['wait_for_specimen']
P['patient_registration'] >> T['received_existing_patient_registration_message'] >> P['rejected_message_patient_registration']

puts 1
