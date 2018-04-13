class GithubApiConstants

  GITHUB_ROOT = "https://api.github.com"

  # export GITHUB_ACCESS_TOKEN = ''
  GITHUB_ACCESS_TOKEN = ENV['GITHUB_ACCESS_TOKEN'] || ''

  GITHUB_API_LIMIT_REACHED_MESSAGE = "Github API Limit Reached. Please export GITHUB_ACCESS_TOKEN to make authenticated requests."

end