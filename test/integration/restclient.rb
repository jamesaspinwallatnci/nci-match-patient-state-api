require "rest-client"

id=100

puts RestClient::Request.execute(
    method: :post,
    url: 'http://localhost:3000/patient_state',
    timeout: 9000000,
    payload: {
        statudyId: 'EAY131',
        patientSequenceNumber: id,
        stepNumber: '0',
        dateCreated: '2014-10-26T13:11:35.244-04:00'
    })
