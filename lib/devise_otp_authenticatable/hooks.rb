# frozen_string_literal: true

module DeviseOtpAuthenticatable
  module Hooks
    autoload :Sessions, 'devise_otp_authenticatable/hooks/sessions.rb'

    class << self
      def apply
        ::Devise::SessionsController.include Hooks::Sessions
      end
    end
  end
end
