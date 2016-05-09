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
            # it "sends patient registration message" do
            #
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "10368",
            #         "stepNumber": "0",
            #         "patientStatus": "REGISTRATION",
            #         "message": "Patient registration to step 0.",
            #         "dateCreated": "2015-11-04T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            #
            # end
            #
            # it "sends specimen received message " do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "10368",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "reportedDate": "2015-11-04T07:10:05.057-05:00",
            #         "status": "CONFIRMED",
            #         "message": "SPECIMEN_RECEIVED"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end
            #
            # it "sends nucleic acid sendout message " do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "10368",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "molecularSequenceNumber": "101000_1000_N-1-0000",
            #         "destinationSite": "Local",
            #         "trackingNumber": "1234",
            #         "dnaConcentration": ".55",
            #         "dnaVolume": "36",
            #         "cDnaConcentration": ".30",
            #         "cDnaVolume": "25",
            #         "reportedDate": "2015-11-04T07:10:05.057-05:00",
            #         "status": "CONFIRMED",
            #         "message": "NUCLEIC_ACID_SENDOUT"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "Patient has taken treatment but disease has progressed." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "10368",
            #         "stepNumber": "2",
            #         "patientStatus": "PROGRESSION",
            #         "message": "Patient has taken treatment but disease has progressed.",
            #         "dateCreated": "2015-11-05T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "Patient is now off trial." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "10368",
            #         "stepNumber": "3",
            #         "patientStatus": "OFF_TRIAL",
            #         "message": "Patient is now off trial.",
            #         "dateCreated": "2015-11-06T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "Patient registration to assigned treatment arm." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "message": "Patient registration to assigned treatment arm EAY131-Q",
            #         "patientSequenceNumber": "10495",
            #         "status": "ON_TREATMENT_ARM",
            #         "treatmentArmName": "Ado-trastuzumab emtansine (TDM1) in HER2 Amplification",
            #         "stepNumber": "1",
            #         "treatmentArmId": "EAY131-Q"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "Teatment arm is currently suspended." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "message": "Teatment arm EAY131-Q is currently suspended",
            #         "patientSequenceNumber": "10495",
            #         "status": "TREATMENT_ARM_SUSPENDED",
            #         "treatmentArmName": "Ado-trastuzumab emtansine (TDM1) in HER2 Amplification",
            #         "stepNumber": "1",
            #         "treatmentArmId": "EAY131-Q"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "Patient is not eligible for treatment arm." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "message": "Patient is not eligible for treatment arm EAY131-Q",
            #         "patientSequenceNumber": "10495",
            #         "status": "NOT_ELIGIBLE",
            #         "treatmentArmName": "Ado-trastuzumab emtansine (TDM1) in HER2 Amplification",
            #         "stepNumber": "1",
            #         "treatmentArmId": "EAY131-Q"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "MDA Specimen Failure Message." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "101000",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "reportedDate": "2015-11-04T07:10:05.057-05:00",
            #         "message": "SPECIMEN_FAILURE"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "MDA ICCPENs Assay Ordered Message." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "101000",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "biomarker": "ICCPTENs",
            #         "orderedDate": "2015-11-04T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end
            #
            # it "MDA ICCPENs Assay Result Message." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "101000",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "biomarker": "ICCPTENs",
            #         "result": "POSITIVE",
            #         "reportedDate": "2015-11-04T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "MDA MLH1 Assay Ordered Message." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "101000",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "biomarker": "ICCMLH1",
            #         "orderedDate": "2015-11-04T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end
            # 
            # it "MDA MLH1 Assay Result Message." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "101000",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "biomarker": "ICCMLH1",
            #         "result": "POSITIVE",
            #         "reportedDate": "2015-11-04T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "MDA MSH2 Assay Ordered Message." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "101000",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "biomarker": "ICCMSH2",
            #         "orderedDate": "2015-11-04T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end
            #
            # it "MDA MSH2 Assay Result Message." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "101000",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "biomarker": "ICCMSH2",
            #         "result": "POSITIVE",
            #         "reportedDate": "2015-11-04T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            # it "MDA RB Assay Ordered Message." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "101000",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "biomarker": "ICCRB",
            #         "orderedDate": "2015-11-04T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end
            #
            # it "MDA RB Assay Result Message." do
            #     post '/patient_state', {
            #         "studyId": "EAY131",
            #         "patientSequenceNumber": "101000",
            #         "biopsySequenceNumber": "N-1-0000",
            #         "biomarker": "ICCRB",
            #         "result": "POSITIVE",
            #         "reportedDate": "2015-11-04T07:10:05.057-05:00"
            #     }, {
            #              "ACCEPT" => "application/json", # This is what Rails 4 accepts
            #              "HTTP_ACCEPT" => "application/json" # This is what Rails 3 accepts
            #          }
            #     expect(response.content_type).to eq("application/json")
            #     expect(response).to have_http_status(:ok)
            # end

            it "MDA Pathology Confirmation Message" do
                post '/patient_state', {
                    "studyId": "EAY131",
                    "patientSequenceNumber": "101000",
                    "biopsySequenceNumber": "N-1-0000",
                    "reportedDate": "2015-11-04T07:10:05.057-05:00",
                    "status": "Y",
                    "message": "PATHOLOGY_CONFIRMATION"
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
