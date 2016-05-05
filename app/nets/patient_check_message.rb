load 'patient_registration_net.rb'

Node.destroy_all
Patient.destroy_all


P['patient_registration'].set('patient_registration_1') {
    @psn=12345
}

P['patient_registration'].set('patient_registration_2') {
    @mark = 1
}

P['patient_registration'].set('patient_registration_3') {
    @mark = 1
}
puts 'patient_registration done'
