class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!
end
