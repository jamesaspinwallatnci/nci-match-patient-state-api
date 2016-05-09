PNet.new(PatientState)

P.new('message')
P.new('registered')
P.new('msg_patient_registration')
P.new('wait_for_specimen')
P.new('msg_specimen_received')
P.new('wait_for_nucleic_acid')
P.new('msg_nucleic_acid_sendout')
P.new('wait_for_variant_report')
P.new('output')

P.new('msg_progression')
P.new('msg_off_trial')
P.new('msg_on_treatment_arm')
P.new('msg_treatment_arm_suspended')
P.new('msg_patient_not_eligible')
P.new('msg_specimen_failure')
P.new('msg_pten_ordered')
P.new('msg_pten_result')
P.new('msg_mlh1_ordered')
P.new('msg_mlh1_result')
P.new('msg_msh2_ordered')
P.new('msg_msh2_result')
P.new('msg_rb_ordered')
P.new('msg_rb_result')
P.new('msg_pathology_confirmation')

T.new('is_patient_registration') {
    @message.patientStatus == 'REGISTRATION' and
        @msg_patient_registration.empty?
}.execute {
    @msg_patient_registration.studyId = @message.studyId
    @msg_patient_registration.patientSequenceNumber = @message.patientSequenceNumber
    @msg_patient_registration.stepNumber = @message.stepNumber
    @msg_patient_registration.patientStatus = @message.patientStatus
    @msg_patient_registration.message = @message.message
    @msg_patient_registration.dateCreated = @message.dateCreated
    @message.clear
}

T.new('is_specimen_received') {
    @message.message == 'SPECIMEN_RECEIVED' and
        @message.status == 'CONFIRMED'and
        @msg_specimen_received.empty?
}.execute {
    @msg_specimen_received.studyId = @message.studyId
    @msg_specimen_received.patientSequenceNumber = @message.patientSequenceNumber
    @msg_specimen_received.message = @message.message
    @msg_specimen_received.status = @message.status
    @msg_specimen_received.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_specimen_received.reportedDate = @message.reportedDate
    @message.clear
}

T.new('is_msg_nucleic_acid_sendout') {
    @message.message == 'NUCLEIC_ACID_SENDOUT' and
        @message.status == 'CONFIRMED'and
        @msg_nucleic_acid_sendout.empty?
}.execute {
    @msg_nucleic_acid_sendout.studyId = @message.studyId
    @msg_nucleic_acid_sendout.patientSequenceNumber = @message.patientSequenceNumber
    @msg_nucleic_acid_sendout.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_nucleic_acid_sendout.molecularSequenceNumber = @message.molecularSequenceNumber
    @msg_nucleic_acid_sendout.destinationSite = @message.destinationSite
    @msg_nucleic_acid_sendout.trackingNumber = @message.trackingNumber
    @msg_nucleic_acid_sendout.dnaConcentration = @message.dnaConcentration
    @msg_nucleic_acid_sendout.cDnaConcentration = @message.cDnaConcentration
    @msg_nucleic_acid_sendout.cDnaVolume = @message.cDnaVolume
    @msg_nucleic_acid_sendout.reportedDate = @message.reportedDate
    @msg_nucleic_acid_sendout.status = @message.status
    @msg_nucleic_acid_sendout.message = @message.message
    @message.clear
}

T.new('is_msg_progression') {
    @message.patientStatus == 'PROGRESSION' and
        @msg_progression.empty?
}.execute {
    @msg_progression.studyId = @message.studyId
    @msg_progression.patientSequenceNumber = @message.patientSequenceNumber
    @msg_progression.stepNumber = @message.stepNumber
    @msg_progression.patientStatus = @message.patientStatus
    @msg_progression.message = @message.message
    @msg_progression.dateCreated = @message.dateCreated
    @message.clear
}

T.new('is_msg_off_trial') {
    @message.patientStatus == 'OFF_TRIAL' and
        @msg_off_trial.empty?
}.execute {
    @msg_off_trial.studyId = @message.studyId
    @msg_off_trial.patientSequenceNumber = @message.patientSequenceNumber
    @msg_off_trial.stepNumber = @message.stepNumber
    @msg_off_trial.patientStatus = @message.patientStatus
    @msg_off_trial.message = @message.message
    @msg_off_trial.dateCreated = @message.dateCreated
    @message.clear
}

T.new('is_msg_on_treatment_arm') {
    @message.status == 'ON_TREATMENT_ARM' and
        @msg_on_treatment_arm.empty?
}.execute {
    @msg_on_treatment_arm.studyId = @message.studyId
    @msg_on_treatment_arm.message = @message.message
    @msg_on_treatment_arm.patientSequenceNumber = @message.patientSequenceNumber
    @msg_on_treatment_arm.status = @message.status
    @msg_on_treatment_arm.treatmentArmName = @message.treatmentArmName
    @msg_on_treatment_arm.stepNumber = @message.stepNumber
    @msg_on_treatment_arm.treatmentArmId = @message.treatmentArmId
    @message.clear
}


T.new('is_msg_treatment_arm_suspended') {
    @message.status == 'TREATMENT_ARM_SUSPENDED' and
        @msg_treatment_arm_suspended.empty?
}.execute {
    @msg_treatment_arm_suspended.studyId = @message.studyId
    @msg_treatment_arm_suspended.message = @message.message
    @msg_treatment_arm_suspended.patientSequenceNumber = @message.patientSequenceNumber
    @msg_treatment_arm_suspended.status = @message.status
    @msg_treatment_arm_suspended.treatmentArmName = @message.treatmentArmName
    @msg_treatment_arm_suspended.stepNumber = @message.stepNumber
    @msg_treatment_arm_suspended.treatmentArmId = @message.treatmentArmId
    @message.clear
}

T.new('is_msg_patient_not_eligible') {
    @message.status == 'NOT_ELIGIBLE' and
        @msg_patient_not_eligible.empty?
}.execute {
    @msg_patient_not_eligible.studyId = @message.studyId
    @msg_patient_not_eligible.message = @message.message
    @msg_patient_not_eligible.patientSequenceNumber = @message.patientSequenceNumber
    @msg_patient_not_eligible.status = @message.status
    @msg_patient_not_eligible.treatmentArmName = @message.treatmentArmName
    @msg_patient_not_eligible.stepNumber = @message.stepNumber
    @msg_patient_not_eligible.treatmentArmId = @message.treatmentArmId
    @message.clear
}

T.new('is_msg_specimen_failure') {
    @message.message == 'SPECIMEN_FAILURE' and
        @msg_specimen_failure.empty?
}.execute {
    @msg_specimen_failure.studyId = @message.studyId
    @msg_specimen_failure.patientSequenceNumber = @message.patientSequenceNumber
    @msg_specimen_failure.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_specimen_failure.reportedDate = @message.reportedDate
    @msg_specimen_failure.message = @message.message
    @message.clear
}


T.new('is_msg_pten_ordered') {
    @message.biomarker == 'ICCPTENs' and
        @message.result.nil? and
        @msg_pten_ordered.empty?
}.execute {
    @msg_pten_ordered.studyId = @message.studyId
    @msg_pten_ordered.patientSequenceNumber = @message.patientSequenceNumber
    @msg_pten_ordered.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_pten_ordered.biomarker = @message.biomarker
    @msg_pten_ordered.orderedDate = @message.orderedDate
    @message.clear
}


T.new('is_msg_pten_result') {
    @message.biomarker == 'ICCPTENs' and
        not @message.result.nil? and
        @msg_pten_result.empty?
}.execute {
    @msg_pten_result.studyId = @message.studyId
    @msg_pten_result.patientSequenceNumber = @message.patientSequenceNumber
    @msg_pten_result.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_pten_result.biomarker = @message.biomarker
    @msg_pten_result.result = @message.result
    @msg_pten_result.reportedDate = @message.reportedDate
    @message.clear
}

T.new('is_msg_mlh1_ordered') {
    @message.biomarker == 'ICCMLH1' and
        @message.result.nil? and
        @msg_mlh1_ordered.empty?
}.execute {
    @msg_mlh1_ordered.studyId = @message.studyId
    @msg_mlh1_ordered.patientSequenceNumber = @message.patientSequenceNumber
    @msg_mlh1_ordered.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_mlh1_ordered.biomarker = @message.biomarker
    @msg_mlh1_ordered.orderedDate = @message.orderedDate
    @message.clear
}


T.new('is_msg_mlh1_result') {
    @message.biomarker == 'ICCMLH1' and
        not @message.result.nil? and
        @msg_mlh1_result.empty?
}.execute {
    @msg_mlh1_result.studyId = @message.studyId
    @msg_mlh1_result.patientSequenceNumber = @message.patientSequenceNumber
    @msg_mlh1_result.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_mlh1_result.biomarker = @message.biomarker
    @msg_mlh1_result.result = @message.result
    @msg_mlh1_result.reportedDate = @message.reportedDate
    @message.clear
}

T.new('is_msg_msh2_ordered') {
    @message.biomarker == 'ICCMSH2' and
        @message.result.nil? and
        @msg_msh2_ordered.empty?
}.execute {
    @msg_msh2_ordered.studyId = @message.studyId
    @msg_msh2_ordered.patientSequenceNumber = @message.patientSequenceNumber
    @msg_msh2_ordered.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_msh2_ordered.biomarker = @message.biomarker
    @msg_msh2_ordered.orderedDate = @message.orderedDate
    @message.clear
}


T.new('is_msg_msh2_result') {
    @message.biomarker == 'ICCMSH2' and
        not @message.result.nil? and
        @msg_msh2_result.empty?
}.execute {
    @msg_msh2_result.studyId = @message.studyId
    @msg_msh2_result.patientSequenceNumber = @message.patientSequenceNumber
    @msg_msh2_result.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_msh2_result.biomarker = @message.biomarker
    @msg_msh2_result.result = @message.result
    @msg_msh2_result.reportedDate = @message.reportedDate
    @message.clear
}

T.new('is_msg_rb_ordered') {
    @message.biomarker == 'ICCRB' and
        @message.result.nil? and
        @msg_rb_ordered.empty?
}.execute {
    @msg_rb_ordered.studyId = @message.studyId
    @msg_rb_ordered.patientSequenceNumber = @message.patientSequenceNumber
    @msg_rb_ordered.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_rb_ordered.biomarker = @message.biomarker
    @msg_rb_ordered.orderedDate = @message.orderedDate
    @message.clear
}


T.new('is_msg_rb_result') {
    @message.biomarker == 'ICCRB' and
        not @message.result.nil? and
        @msg_rb_result.empty?
}.execute {
    @msg_rb_result.studyId = @message.studyId
    @msg_rb_result.patientSequenceNumber = @message.patientSequenceNumber
    @msg_rb_result.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_rb_result.biomarker = @message.biomarker
    @msg_rb_result.result = @message.result
    @msg_rb_result.reportedDate = @message.reportedDate
    @message.clear
}

T.new('is_msg_pathology_confirmation') {
    @message.message == 'PATHOLOGY_CONFIRMATION' and
        @msg_pathology_confirmation.empty?
}.execute {
    @msg_pathology_confirmation.studyId = @message.studyId
    @msg_pathology_confirmation.patientSequenceNumber = @message.patientSequenceNumber
    @msg_pathology_confirmation.biopsySequenceNumber = @message.biopsySequenceNumber
    @msg_pathology_confirmation.reportedDate = @message.reportedDate
    @msg_pathology_confirmation.status = @message.status
    @msg_pathology_confirmation.message = @message.message
    @message.clear
}

P['message'] >> T['is_patient_registration'] >> P['msg_patient_registration']
P['message'] >> T['is_specimen_received'] >> P['msg_specimen_received']
P['message'] >> T['is_msg_nucleic_acid_sendout'] >> P['msg_nucleic_acid_sendout']
P['message'] >> T['is_msg_progression'] >> P['msg_progression']
P['message'] >> T['is_msg_off_trial'] >> P['msg_off_trial']
P['message'] >> T['is_msg_on_treatment_arm'] >> P['msg_on_treatment_arm']
P['message'] >> T['is_msg_treatment_arm_suspended'] >> P['msg_treatment_arm_suspended']
P['message'] >> T['is_msg_patient_not_eligible'] >> P['msg_patient_not_eligible']
P['message'] >> T['is_msg_specimen_failure'] >> P['msg_specimen_failure']
P['message'] >> T['is_msg_pten_ordered'] >> P['msg_pten_ordered']
P['message'] >> T['is_msg_pten_result'] >> P['msg_pten_result']
P['message'] >> T['is_msg_mlh1_ordered'] >> P['msg_mlh1_ordered']
P['message'] >> T['is_msg_mlh1_result'] >> P['msg_mlh1_result']
P['message'] >> T['is_msg_msh2_ordered'] >> P['msg_msh2_ordered']
P['message'] >> T['is_msg_msh2_result'] >> P['msg_msh2_result']
P['message'] >> T['is_msg_rb_ordered'] >> P['msg_rb_ordered']
P['message'] >> T['is_msg_rb_result'] >> P['msg_rb_result']
P['message'] >> T['is_msg_pathology_confirmation'] >> P['msg_pathology_confirmation']

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

