class RepoController < ApplicationController
  include RepoHelper

  def changed_files
    render json: compute_changed_and_risk_files(params)
  end


end
