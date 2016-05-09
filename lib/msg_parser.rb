class MsgParser

    @@state_process_hash = {
        ["dateCreated", "patientSequenceNumber", "statudyId", "stepNumber"] =>
            ['msg_patient_registration', 'msg_patient_registration_processor'],
        ["biopsySequenceNumber", "message", "patientSequenceNumber", "reportedDate"] =>
            ['msg_specimen_received', 'msg_specimen_received_processor'],
        ["biopsySequenceNumber", "cDnaConcentration", "cDnaVolume", "comment", "destinationSite", "dnaConcentration", "dnaVolume", "message", "molecularSequenceNumber", "patientSequenceNumber", "reportedDate", "trackingNumber"] =>
            ['msg_nucleic_acid_sendout', 'msg_nucleic_acid_sendout_processor']
    }

    class << self
        def state_process(msg)

            data = msg.to_hash
            data.delete('controller')
            data.delete('action')

            state, process = @@state_process_hash[data.keys.sort]
            id = data['patientSequenceNumber']
            [id, state, process, data]
        end
    end
end

puts 'MsgParser loaded'
