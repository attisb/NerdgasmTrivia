# This file is used by Rack-based servers to start the application.

worker_processes 3

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
