require 'pry'
module RolloutUi
  class ApplicationController < ActionController::Base
    user      = RolloutUi.config.rails_user rescue nil
    password  = RolloutUi.config.rails_password rescue nil
    if user && password
      http_basic_authenticate_with name: user, password: password
    end
  end
end
