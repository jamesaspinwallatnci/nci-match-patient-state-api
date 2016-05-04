module Mongo
    class Patient
        include Mongoid::Document
        include Mongoid::Attributes::Dynamic
        store_in collection: 'patient'

        field :patientSequenceNumber, type: Integer
        field :currentPatientStatus
        field :ethnicity
        field :gender
        field :registrationDate, type: Time

    end
end

=begin

Mongo::Patient.all.map &:patientSequenceNumber

attr = [
    :patientSequenceNumber,
    :currentPatientStatus,
    :ethnicity,
    :gender,
    :registrationDate
]

Mongo::Patient.all.pluck(*attr).each { |rec|
    dyn = Dynamo::Patient.new
    rec.collect.with_index { |field, index|
        dyn[attr[index]]=field
    }
    dyn.save
}

=end



