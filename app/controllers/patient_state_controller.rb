class PatientStateController < ApplicationController

    def index
        render json: PatientState.all
    end

    def show
        render json: PatientState.find(params['id'])
    end

    def create

        id,state,processor,data = MsgParser.state_process(params)

        PNet.default.load(id)
        P[state].set(processor,data)

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
