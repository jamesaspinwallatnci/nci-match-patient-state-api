load 'patient_registration_net.rb'


Net.default.delete_all
Net.default.load('119re')

puts 'msg_patient_registration'

P['msg_patient_registration']
    .set('msg_patient_registration_processor',
         {
             statudyId: 'EAY131',
             patientSequenceNumber: '119re',
             stepNumber: '0',
             dateCreated: '2014-10-26T13:11:35.244-04:00'
         })

puts 'msg_specimen_received'
P['msg_specimen_received']
    .set('msg_specimen_received_processor',
         {
             patientSequenceNumber: '200re',
             biopsySequenceNumber: 'N-15-00005',
             reportedDate: '2016-02-18 14:52:40 UTC',
             message: 'SPECIMEN_RECEIVED'
         })


puts 'msg_nucleic_acid_sendout'
P['msg_nucleic_acid_sendout']
    .set('msg_nucleic_acid_sendout_processor',
         {

             molecularSequenceNumber: '201_N-15-00005',
             destinationSite: 'Boston',
             trackingNumber: '987654321',
             dnaConcentration: '.55',
             dnaVolume: '36',
             cDnaConcentration: '.30',
             cDnaVolume: '25',
             patientSequenceNumber: '201re',
             biopsySequenceNumber: 'N-15-00005',
             reportedDate: '2016-04-14T17:00:15.475Z',
             comment: 'This is a nucleic acids shipping message comment.',
             message: 'NUCLEIC_ACID_SENDOUT'


         })

puts 'END'
