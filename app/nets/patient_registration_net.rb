PNet.new(PatientState)

P.new('message')
P.new('registered')
P.new('msg_patient_registration')
P.new('wait_for_specimen')
P.new('msg_specimen_received')
P.new('wait_for_nucleic_acid')
P.new('msg_nucleic_acid_sendout')
P.new ('wait_for_variant_report')
P.new('output')
P.new('rendered')

T.new('is_patient_registration') {
    @message.patientStatus == 'REGISTRATION' and
        @msg_patient_registration.empty?
}.execute {
    @msg_patient_registration.studyId = @message.studyId
    @msg_patient_registration.patientSequenceNumber  = @message.patientSequenceNumber
    @msg_patient_registration.stepNumber = @message.stepNumber
    @msg_patient_registration.patientStatus = @message.patientStatus
    @msg_patient_registration.message = @message.message
    @msg_patient_registration.dateCreated  = @message.dateCreated
    @message.clear
}

T.new('is_specimen_received') {
    @message.message == 'SPECIMEN_RECEIVED' and
        @message.status == 'CONFIRMED'and
        @msg_specimen_received.empty?
}.execute {
    @msg_specimen_received.studyId = @message.studyId
    @msg_specimen_received.patientSequenceNumber  = @message.patientSequenceNumber
    @msg_specimen_received.message = @message.message
    @msg_specimen_received.status = @message.status
    @msg_specimen_received.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_specimen_received.reportedDate  = @message.reportedDate
    @message.clear
}

T.new('is_msg_nucleic_acid_sendout') {
    @message.message == 'NUCLEIC_ACID_SENDOUT' and
        @message.status == 'CONFIRMED'and
        @msg_nucleic_acid_sendout.empty?
}.execute {
    @msg_nucleic_acid_sendout.studyId = @message.studyId
    @msg_nucleic_acid_sendout.patientSequenceNumber  = @message.patientSequenceNumber
    @msg_nucleic_acid_sendout.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_nucleic_acid_sendout.molecularSequenceNumber = @message.molecularSequenceNumber
    @msg_nucleic_acid_sendout.destinationSite = @message.destinationSite
    @msg_nucleic_acid_sendout.trackingNumber  = @message.trackingNumber
    @msg_nucleic_acid_sendout.dnaConcentration  = @message.dnaConcentration
    @msg_nucleic_acid_sendout.cDnaConcentration = @message.cDnaConcentration
    @msg_nucleic_acid_sendout.cDnaVolume = @message.cDnaVolume
    @msg_nucleic_acid_sendout.reportedDate = @message.reportedDate
    @msg_nucleic_acid_sendout.status = @message.status
    @msg_nucleic_acid_sendout.message = @message.message
    @message.clear
}



P['message'] >> T['is_patient_registration'] >> P['msg_patient_registration']
P['message'] >> T['is_specimen_received'] >> P['msg_specimen_received']
P['message'] >> T['is_msg_nucleic_acid_sendout'] >> P['msg_nucleic_acid_sendout']

T.new('register_patient') {
    @msg_patient_registration.not_empty? and
        @wait_for_specimen.empty? and
        @registered.empty?

}.execute {
    @registered.mark = true
    @wait_for_specimen.mark = true
    @output.status = 'success'
    @output.transition = 'register_patient'
}

T.new('receive_specimen') {
    @msg_specimen_received.not_empty? and
        @wait_for_specimen.not_empty? and
        @wait_for_nucleic_acid.empty?


}.execute {
    @wait_for_nucleic_acid.mark = true
    @wait_for_specimen.clear
    @output.status = 'success'
    @output.transition = 'receive_specimen'
}

T.new('receive_nucleic_acid_sendout') {
    @msg_nucleic_acid_sendout.not_empty? and
        @wait_for_nucleic_acid.not_empty? and
        @wait_for_variant_report.empty?

}.execute {
    @wait_for_variant_report.mark = true
    @wait_for_nucleic_acid.clear
    @output.status = 'success'
    @output.transition = 'receive_nucleic_acid_sendout'
}

[P['registered'], P['msg_patient_registration']] >> T['register_patient'] >>
    P['wait_for_specimen'] >> T['receive_specimen'] >>
    P['wait_for_nucleic_acid'] >> T['receive_nucleic_acid_sendout'] >>
    P['wait_for_variant_report']


P['msg_specimen_received'] >> T['receive_specimen']

P['msg_nucleic_acid_sendout'] >> T['receive_nucleic_acid_sendout']

[T['register_patient'], T['receive_specimen'], T['receive_nucleic_acid_sendout']] >> P['output']

