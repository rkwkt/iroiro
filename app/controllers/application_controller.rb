class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    I18n.locale = current_user&.locale || :ja
  end
end
