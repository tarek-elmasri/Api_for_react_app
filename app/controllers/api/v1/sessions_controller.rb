class Api::V1::SessionsController < ApplicationController

  def sign_up
    user=User.new(sessions_params)
    if user.save
      render json:{ user: {
          token: user.generate_token,
          username: user.username,
          email: user.email
          }
        },status: :created
    else
      render json: {errors: user.errors},status: :unprocessable_entity
    end
  end

  def login
    user = User.new.login(params['user']['email'], params['user']['password'])
    if user
      render json: {user: {
        token: user.generate_token,
        username: user.username,
        email: user.email
        }},status: :ok
    else
      render json: {errors: ['Invalid email or password']},status: :unprocessable_entity
    end
  end

  def authByToken
    user=User.new.user_by(params['token'])
    if user
      render json: {user: {
        token: user.generate_token,
        username: user.username,
        email: user.email
      }},status: :ok
    else
      render json: {errors: ['user not found']},status: :unauthorized
    end


  end

  private
  def sessions_params
    params.permit(:username,:password,:password_confirmation,:email)
  end
end
