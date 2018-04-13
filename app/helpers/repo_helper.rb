require_relative '../../app/exceptions/repo_exception_handler'
require_relative '../../app/constants/github_api_constants'

module RepoHelper

  include RepoExceptionHandler

  # GET /repos/:owner/:repo/commits
  # Parameters path, since - ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ, until - ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ
  # Returning RepoNotFound if user or repo is wrong.
  # Assuming last 30 days from current time.
  def get_last_30_days_commits(user, repo)
    current_time = Time.now.strftime("%Y-%m-%dT%H:%M:%SZ")
    since = (Time.parse(current_time) - 30.days).strftime("%Y-%m-%dT%H:%M:%SZ")
    uptil = current_time
    begin
      github_api_response = RestClient.get("#{GithubApiConstants::GITHUB_ROOT}/repos/#{user}/#{repo}/commits?path=/&since=#{since}&until=#{uptil}&access_token=#{GithubApiConstants::GITHUB_ACCESS_TOKEN}")
      JSON.parse(github_api_response).collect{|o| o["sha"]}
    rescue RestClient::NotFound => e
      raise RepoExceptionHandler::RepoNotFound.new("repo #{repo} not found")
    rescue RestClient::Forbidden => e
      raise RepoExceptionHandler::GithubAPILimitReached.new(GithubApiConstants::GITHUB_API_LIMIT_REACHED_MESSAGE)
    end
  end


  # Assuming that we have to return all authors for risked files. Not just 2. Hence need to make all github commits sha calls.
  def compute_changed_and_risk_files(params)
    commit_hash, file_arr = commit_info(params)
    changed_file_freq = file_arr.flatten!.each_with_object(Hash.new(0)) {|file, freq_acc| freq_acc[file] += 1}
    changed_g2_files = []
    changed_file_freq.select {|file, freq| changed_g2_files << file if freq > 2}
    risk_files = changed_g2_files.dup
    rf = risk_files.each_with_object({}) do |file, acc|
      author_set = Set.new
      commit_hash.each do |file_arr, author|
        acc[file] = (author_set << author ) if file_arr.include? (file)
      end
    end
    rf.delete_if {|_file, author_arr| author_arr.length < 2}
    {
        "changed_files" => changed_g2_files,
        "risk_files" => rf
    }
  end

  # GET /repos/:owner/:repo/commits/:sha
  # Using Typhoeus Http Client to make parallel requests. Performs far better than RestClient for multiple parallel calls.
  def commit_info(params)
    user, repo = params["user"], params["repo"]
    shas = get_last_30_days_commits(user, repo)
    commit_hash = {}
    file_arr = []
    hydra = Typhoeus::Hydra.new
    shas.each do |sha|
      request = Typhoeus::Request.new("#{GithubApiConstants::GITHUB_ROOT}/repos/#{user}/#{repo}/commits/#{sha}?access_token=#{GITHUB_ACCESS_TOKEN}")
      request.on_complete do |response|
        if response.success?
          parsed_sha_info = JSON.parse(response.response_body)
          author = parsed_sha_info["commit"]["author"]["name"]
          files = parsed_sha_info["files"].collect { |f| f["filename"] }
          commit_hash[files] = author
          file_arr << files
        else
          raise RepoExceptionHandler::GithubAPILimitReached.new(GithubApiConstants::GITHUB_API_LIMIT_REACHED_MESSAGE)
        end
      end
      hydra.queue(request)
    end
    hydra.run
    return commit_hash, file_arr
  end

end