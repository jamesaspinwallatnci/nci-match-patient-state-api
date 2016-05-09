require "rails_helper"

RSpec.describe "External Requests", :type => :request do

    # it "get patients state" do
    #     get "/patient_state"
    #     expect(true).to eq(true)
    #     expect(response.content_type).to eq("application/json")
    #     expect(response).to have_http_status(:ok)
    # end

    describe PatientState do
        before(:all) do
            PatientState.delete_all
        end

        describe "initialized in before(:each)" do
            it "sends patient registration message" do

                post '/patient_state', {
                    "studyId": "EAY131",
                    "patientSequenceNumber": "10368",
                    "stepNumber": "0",
                    "patientStatus": "REGISTRATION",
                    "message": "Patient registration to step 0.",
                    "dateCreated": "2015-11-04T07:10:05.057-05:00"
                }, {
                         "ACCEPT" => "application/json", # This is what Rails 4 accepts
                         "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
                     }
                expect(response.content_type).to eq("application/json")
                expect(response).to have_http_status(:ok)

            end

            it "sends specimen received message " do
                post '/patient_state', {
                    "studyId": "EAY131",
                    "patientSequenceNumber": "10368",
                    "biopsySequenceNumber": "N-1-0000",
                    "reportedDate": "2015-11-04T07:10:05.057-05:00",
                    "status": "CONFIRMED",
                    "message": "SPECIMEN_RECEIVED"
                }, {
                         "ACCEPT" => "application/json", # This is what Rails 4 accepts
                         "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
                     }
                expect(response.content_type).to eq("application/json")
                expect(response).to have_http_status(:ok)
            end

            it "sends nucleic acid sendout message " do
                post '/patient_state', {
                    "studyId": "EAY131",
                    "patientSequenceNumber": "10368",
                    "biopsySequenceNumber": "N-1-0000",
                    "molecularSequenceNumber": "101000_1000_N-1-0000",
                    "destinationSite": "Local",
                    "trackingNumber": "1234",
                    "dnaConcentration": ".55",
                    "dnaVolume": "36",
                    "cDnaConcentration": ".30",
                    "cDnaVolume": "25",
                    "reportedDate": "2015-11-04T07:10:05.057-05:00",
                    "status": "CONFIRMED",
                    "message": "NUCLEIC_ACID_SENDOUT"
                }, {
                         "ACCEPT" => "application/json", # This is what Rails 4 accepts
                         "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
                     }
                expect(response.content_type).to eq("application/json")
                expect(response).to have_http_status(:ok)
            end
        end
    end
end
