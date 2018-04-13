module RepoExceptionHandler
  class RepoNotFound < Exception
    attr_accessor :message, :code

    def initialize(message, code = 404)
      @message = message
    end

  end

  class GithubAPILimitReached < Exception

    attr_accessor :message, :code

    def initialize(message, code = 403)
      @message = message
    end

  end

end