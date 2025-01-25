module Rememberable
  extend ActiveSupport::Concern

  included do
    attr_accessor :remember_token

    def remember_me
      self.remember_token = SecureRandom.urlsafe_base64
      update_column :remember_token_digest, digest(remember_token)
    end

    def forget_me
      update_column :remember_token_digest, nil
      self.remember_token = nil
    end

    def remember_token_authenticated?(remember_token)
      return false if remember_token_digest.blank?
      BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
    end
  end
end
