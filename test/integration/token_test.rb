# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../integration_tests_helper'

class TokenTest < ActionDispatch::IntegrationTest
  def teardown
    Capybara.reset_sessions!
  end

  test 'disabling OTP after successfully enabling' do
    # log in 1fa
    user = enable_otp_and_sign_in
    assert_equal user_otp_credential_path, current_path

    # otp 2fa
    fill_in 'user[token]', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.zone.now)
    click_button 'Submit Token'
    assert_equal root_path, current_path

    # disable OTP
    disable_otp

    # logout
    sign_out

    # log back in 1fa
    sign_user_in(user)

    assert_equal root_path, current_path
  end

  test 'visiting setup page after setup complete redirects to settings' do
    # log in 1fa
    user = enable_otp_and_sign_in
    assert_equal user_otp_credential_path, current_path

    # otp 2fa
    fill_in 'user[token]', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.zone.now)
    click_button 'Submit Token'
    assert_equal root_path, current_path

    # visit setup page
    visit new_user_otp_token_path
    assert page.has_button?('Disable 2FA')
  end
end
