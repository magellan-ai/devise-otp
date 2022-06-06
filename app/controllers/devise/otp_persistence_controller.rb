# frozen_string_literal: true

module Devise
  class OtpPersistenceController < DeviseController
    include ::Devise::Controllers::Helpers

    prepend_before_action :ensure_credentials_refresh
    prepend_before_action :authenticate_scope!

    protect_from_forgery only: %i[create]

    #
    # makes the current browser persistent
    #
    def create
      otp_set_flash_message :success, :successfully_set if otp_set_trusted_device_for(resource)

      redirect_to otp_token_path_for(resource)
    end

    #
    # clears persistence for the current browser
    #
    def update
      otp_set_flash_message :success, :successfully_cleared if otp_clear_trusted_device_for(resource)

      redirect_to otp_token_path_for(resource)
    end

    #
    # rehash the persistence secret, thus, making all the persistence cookies invalid
    #
    def destroy
      otp_set_flash_message :notice, :successfully_reset if otp_reset_persistence_for(resource)

      redirect_to otp_token_path_for(resource)
    end

    private

    def ensure_credentials_refresh
      ensure_resource!
      return unless needs_credentials_refresh?(resource)

      otp_set_flash_message :notice, :need_to_refresh_credentials
      redirect_to refresh_otp_credential_path_for(resource)
    end
  end
end
