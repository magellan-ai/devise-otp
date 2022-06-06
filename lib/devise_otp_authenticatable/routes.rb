# frozen_string_literal: true

module ActionDispatch::Routing
  class Mapper
    protected

    def devise_otp(mapping, controllers)
      namespace :otp, module: nil do
        resource :token,
                 path:       mapping.path_names[:token],
                 controller: controllers[:otp_tokens] do
          get :recovery
        end

        resource :credential,
                 only:       %i[show update],
                 path:       mapping.path_names[:credentials],
                 controller: controllers[:otp_credentials] do
          get :refresh, action: :get_refresh
          put :refresh, action: :set_refresh
        end

        if Devise.otp_trust_persistence
          resource :persistence,
                   only:       %i[create update destroy],
                   path:       mapping.path_names[:persistence],
                   controller: controllers[:otp_persistence]
        end
      end
    end
  end
end
