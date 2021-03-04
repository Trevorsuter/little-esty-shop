class ApplicationController < ActionController::Base
  before_action :api

  def api
    @service = GithubService.new
    @repo = RepoName.new(@service.repo_name)
    @contributors = ContributorNames.new(@service.contributors)
  end
end
