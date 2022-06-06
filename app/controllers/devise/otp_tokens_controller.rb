# frozen_string_literal: true

module Devise
  class OtpTokensController < DeviseController
    include ::Devise::Controllers::Helpers

    prepend_before_action :ensure_credentials_refresh
    prepend_before_action :authenticate_scope!

    protect_from_forgery

    #
    # Displays the status of OTP authentication
    #
    def show
      redirect_to(stored_location_for(scope) || :root) unless resource
    end

    #
    # Updates the status of OTP authentication
    #
    def update
      enabled = ActiveModel::Type::Boolean.new.cast(params[resource_name][:otp_enabled])
      success = enabled ? resource.enable_otp! : resource.disable_otp!
      otp_set_flash_message :success, :successfully_updated if success

      render :show
    end

    #
    # Resets OTP authentication, generates new credentials, sets it to off
    #
    def destroy
      otp_set_flash_message :success, :successfully_reset_creds if resource.reset_otp_credentials!

      redirect_to action: :show
    end

    def recovery
      respond_to do |format|
        format.html
        format.js
        format.text do
          send_data render_to_string(template: "#{controller_path}/recovery_codes"), filename: "otp-recovery-codes.txt", format: "text"
        end
      end
    end

    private

    def ensure_credentials_refresh
      ensure_resource!
      return unless needs_credentials_refresh?(resource)

      otp_set_flash_message :notice, :need_to_refresh_credentials
      redirect_to refresh_otp_credential_path_for(resource)
    end

    def scope
      resource_name.to_sym
    end
  end
end
