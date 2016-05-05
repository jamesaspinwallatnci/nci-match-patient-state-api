load 'init.rb'

net = Net.new

P.new('patient_registration')
P.new('wait_for_specimen')
P.new('rejected_message_patient_registration')

T.new('received_new_patient_registration_message') {
    @patient_registration.not_empty? and
        @wait_for_specimen.empty? and
        Patient.not_exists?(@patient_registration.psn)

}.execute {
    @wait_for_specimen.mark = true
    Patient.create(psn: @patient_registration.psn)
    @patient_registration.clear
}

T.new('received_existing_patient_registration_message') {
    @patient_registration.not_empty? and
        Patient.exists?(@patient_registration.psn)

}.execute {
    @rejected_message_patient_registration.count = @rejected_message_patient_registration.count + 1 rescue 1
    @patient_registration.clear
}

P['patient_registration'] >> T['received_new_patient_registration_message'] >> P['wait_for_specimen']
P['patient_registration'] >> T['received_existing_patient_registration_message'] >> P['rejected_message_patient_registration']


