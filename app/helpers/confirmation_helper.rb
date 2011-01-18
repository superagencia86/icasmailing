module ConfirmationHelper

  def confirm_url(contact)
    "http://#{APP.host}#{ConfirmationsController::ACCEPT_URL}/#{contact.confirmation_code}"
  end

  def unconfirm_url(contact)
    "http://#{APP.host}#{ConfirmationsController::REJECT_URL}/#{contact.confirmation_code}"
  end
end
