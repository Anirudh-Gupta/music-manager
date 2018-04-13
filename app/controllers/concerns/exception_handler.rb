require_relative '../../exceptions/repo_exception_handler'
module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern
  include RepoExceptionHandler

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      json_response({ message: e.message }, 409)
    end

    rescue_from RepoExceptionHandler::RepoNotFound do |e|
      json_response({ message: e.message }, 404)
    end

    rescue_from RepoExceptionHandler::GithubAPILimitReached do |e|
      json_response({ message: e.message }, 403)
    end
  end
end