module ExceptionsHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :error_occured
  end

  protected

  def error_occured(e)
    log_error e
    flash[:error] = e.message
    redirect_to root_path
  end

  def log_error(error)
    Rails.logger.error error.message
    error.backtrace.each { |line| Rails.logger.error line }
  end
end
