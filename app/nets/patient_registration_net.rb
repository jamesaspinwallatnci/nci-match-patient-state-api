
PNet.new(PatientState)

P.new('registered')
P.new('msg_patient_registration')
P.new('wait_for_specimen')
P.new('msg_specimen_received')
P.new('wait_for_nucleic_acid')
P.new('msg_nucleic_acid_sendout')
P.new ('wait_for_variant_report')
P.new('output')
P.new('rendered')

T.new('register_patient') {
    @msg_patient_registration.not_empty? and
        @wait_for_specimen.empty? and
        @registered.empty?

}.execute {
    @registered.mark = true
    @wait_for_specimen.mark = true
    @output.status = 'success'
    @output.transition =  'register_patient'
}

T.new('receive_specimen') {
    @msg_specimen_received.not_empty? and
        @wait_for_specimen.not_empty? and
        @wait_for_nucleic_acid.empty?


}.execute {
    @wait_for_nucleic_acid.mark = true
    @wait_for_specimen.clear
    @output.status = 'success'
    @output.transition =  'receive_specimen'
}

T.new('receive_nucleic_acid_sendout') {
    @msg_nucleic_acid_sendout.not_empty? and
        @wait_for_nucleic_acid.not_empty? and
        @wait_for_variant_report.empty?

}.execute {
    @wait_for_variant_report.mark = true
    @wait_for_nucleic_acid.clear
    @output.status = 'success'
    @output.transition =  'receive_nucleic_acid_sendout'
}


[P['registered'],P['msg_patient_registration']] >> T['register_patient'] >>
    P['wait_for_specimen'] >> T['receive_specimen'] >>
    P['wait_for_nucleic_acid'] >> T['receive_nucleic_acid_sendout'] >>
    P['wait_for_variant_report']


P['msg_specimen_received'] >> T['receive_specimen']

P['msg_nucleic_acid_sendout'] >> T['receive_nucleic_acid_sendout']

[T['register_patient'], T['receive_specimen'],T['receive_nucleic_acid_sendout']] >> P['output']

