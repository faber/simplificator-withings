class Withings::ApiError < StandardError
  ERR_MISMATCHED_HASH_EMAIL = 100
  ERR_INVALID_USERID = 247
  ERR_INVALID_OAUTH_CREDENTIALS = 249
  ERR_MISMATCHED_OAUTH_CREDENTIALS = 250
  ERR_INVALID_EMAIL = 264
  ERR_TEMPORARY_SERVER_ERROR = 284
  ERR_INVALID_TOKEN = 283
  ERR_NO_SUBSCRIPTION_FOUND = 286
  ERR_INVALID_CALLBACK_URL = 293
  ERR_CANNOT_DELETE_SUBSCRIPTION = 294
  ERR_INVALID_COMMENT = 304
  ERR_USER_IS_DEACTIVATED = 328
  ERR_INVALID_SIGNATURE = 342
  ERR_NOTIFICATION_NOT_FOUND = 343
  ERR_INVALID_ACTION = 2554
  ERR_UNKNOWN_ERROR = 2555

  UNKNOWN_STATUS_CODE = lambda() {|status, path, params| "Unknown status code '#{status}'"}
  STATUS_CODES = {
    ERR_MISMATCHED_HASH_EMAIL =>
      lambda() {|status, path, params| "The hash '#{params[:hash]}' does not match the email '#{params[:email]}'"},
    ERR_INVALID_USERID =>
      lambda() {|status, path, params| "The userid '#{params[:userid]}' is invalid"},
    ERR_INVALID_OAUTH_CREDENTIALS =>
      lambda() {|status, path, params| "Called an action with invalid oauth credentials"},
    ERR_MISMATCHED_OAUTH_CREDENTIALS =>
      lambda() {|status, path, params| "The userid '#{params[:userid]}' and publickey '#{params[:publickey]}' do not match, or the user does not share its data"},
    ERR_INVALID_EMAIL =>
      lambda() {|status, path, params| "The email address '#{params[:email]}' is either unknown or invalid"},
    ERR_TEMPORARY_SERVER_ERROR =>
      lambda() {|status, path, params| "Temporary Server Error" },
    ERR_INVALID_TOKEN =>
      lambda() {|status, path, params| "Token is invalid or does not exist" },
    ERR_NO_SUBSCRIPTION_FOUND =>
      lambda() {|status, path, params| "No subscription for '#{params[:callbackurl]}' was found" },
    ERR_INVALID_CALLBACK_URL =>
      lambda() {|status, path, params| "The callback URL '#{params[:callbackurl]}' is either unknown or invalid"},
    ERR_CANNOT_DELETE_SUBSCRIPTION =>
      lambda() {|status, path, params| "Could not delete subscription for '#{params[:callbackurl]}'"},
    ERR_INVALID_COMMENT =>
      lambda() {|status, path, params| "The comment '#{params[:comment]}' is invalid"},
    ERR_USER_IS_DEACTIVATED =>
      lambda() {|status, path, params| "The user is deactivated" },
    ERR_INVALID_SIGNATURE =>
      lambda() {|status, path, params| "Failed to verify signature"},
    ERR_NOTIFICATION_NOT_FOUND =>
      lambda() {|status, path, params| "No notification matching the criteria was found: '#{params[:callbackurl]}'"},
    ERR_INVALID_ACTION =>
      lambda() {|status, path, params| "Unknown action '#{params[:action]}' for '#{path}'"},
    ERR_UNKNOWN_ERROR =>
      lambda() {|status, path, params| "An unknown error occurred"},
  }

  attr_reader :status
  def initialize(status, path, params)
    super(build_message(status, path, params))
    @status = status
  end

  def to_s
    super + " - Status code: #{self.status}"
  end


  protected

  def build_message(status, path, params)
    (STATUS_CODES[status] || UNKNOWN_STATUS_CODE).call(status, path, params)
  end
end
