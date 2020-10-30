class User < ApplicationRecord
    has_secure_password

    validates :username , length: {minimum: 2} , uniqueness: true
    validates :email  , presence: true, uniqueness: true
    validates :password , length: {minimum: 2}

    has_many :posts
    
    def generate_token
        exp= 2.minutes.from_now.to_i # 2 minutes token expiration
        data={ id: self.id , email: self.email, exp: exp}
        secret_key= Rails.application.secrets.secret_key_base[0]
        token = JWT.encode( data , secret_key)
    end


    def login(email,password)
        user = User
                    .find_by(email: email)
                    .try(:authenticate, password) # bcrypt gem athentication method embeded in user model (has_secure_password)
    end

    


    def user_by(token)
        if token.present?
            begin
                #validating and decoding token
                secret_key= Rails.application.secrets.secret_key_base[0]
                decoded_token = JWT.decode(token, secret_key)[0]    #recieving data hash from the token
                return User.find_by(email: decoded_token['email'])
            rescue  JWT::DecodeError
                #JWT::ExpiredSignature , JWT::ImmatureSignature , JWT::InvalidIssuerError , JWT::VerificationError,
                return nil
            end
        end 
    end

end
