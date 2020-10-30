class ApplicationController < ActionController::API


    def authenticate_user!
        @current_user= User.new.user_by(params['token'])
        render json: {errors: ['Please Log in first']}, status: :unauthorized unless @current_user.present?
    end

    def only_admin!
        @current_user=User.new.user_by(params['token'])
        render json: {errors: ['Only admins are allowed']},status: :unauthorized unless @current_user&.admin?
    end


end

