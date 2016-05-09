class PatientStateController < ApplicationController

    def index
        render json: PatientState.all
    end

    def show
        render json: PatientState.find(params['id'])
    end

    def create

        PNet.default.load(params['patientSequenceNumber'])
        P['message'].set('message_api',params)

        respond_to do |format|
            format.json {
                render json: P['output'].to_h
            }
        end
    end

    def destroy
        PatientState.all.map &:destroy
        Node.delete_all
        render json: {result: 'success'}
    end
end
