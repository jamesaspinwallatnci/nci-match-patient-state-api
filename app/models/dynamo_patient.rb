module Dynamo
    class Patient
        include Dynamoid::Document

        field :patientSequenceNumber,:integer
        field :currentPatientStatus
        field :ethnicity
        field :gender
        field :registrationDate,:datetime
    end
end


