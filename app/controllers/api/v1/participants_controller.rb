module Api
  module V1
    class ParticipantsController < ActionController::API
      include ActionController::Helpers
      helper ParticipantsHelper

      def user_profile
        username      = params[:username]
        avatar        = params[:avatar]
        truncate      = params[:truncate]
        research_name = params[:research_name]
        participant = Participant.find_by(id: params[:id])

        render partial: 'participants/user_link', locals: { participant: participant, username: username, avatar: avatar, truncate: truncate, research_name: research_name }, layout: false
      end

      def discourse_notifications
        Discourse::NotificationService.new(notification: params['notification']).call
        render json: { message: 'creating' }, status: :ok
      end
    end
  end
end
