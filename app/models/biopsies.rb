class Biopsy
    include Dynamoid::Document

    field :patientSequenceNumber
    field :biopsySequenceNumber
    field :biomarker
    field :result
    field :orderedDate, :datetime
    field :reportedDate , :datetime

end


f=Patient.first
ap f['biopsies'][0]['assayMessages'][1]

Biopsy.create f['biopsies'][0]['assayMessages'][1]
