# frozen_string_literal: true

module DeviseOtpAuthenticatable
  module Controllers
    module UrlHelpers
      def recovery_otp_token_for(resource_or_scope, **opts)
        scope = ::Devise::Mapping.find_scope!(resource_or_scope)
        polymorphic_path([scope, :otp_token], action: :recovery, **opts)
      end

      def refresh_otp_credential_path_for(resource_or_scope, **opts)
        scope = ::Devise::Mapping.find_scope!(resource_or_scope)
        polymorphic_path([scope, :otp_credential], action: :refresh, **opts)
      end

      def otp_persistence_path_for(resource_or_scope, **opts)
        scope = ::Devise::Mapping.find_scope!(resource_or_scope)
        polymorphic_path([scope, :otp_persistence], **opts)
      end

      def otp_token_path_for(resource_or_scope, **opts)
        scope = ::Devise::Mapping.find_scope!(resource_or_scope)
        polymorphic_path([scope, :otp_token], **opts)
      end

      def otp_credential_path_for(resource_or_scope, **opts)
        scope = ::Devise::Mapping.find_scope!(resource_or_scope)
        polymorphic_path([scope, :otp_credential], **opts)
      end
    end
  end
end
