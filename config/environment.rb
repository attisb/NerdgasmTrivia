# Load the Rails application.
require File.expand_path('../application', __FILE__)

Time::DATE_FORMATS[:date_with_time] = "%m.%d.%Y %I:%M%P"
Time::DATE_FORMATS[:date_only] = "%m.%d.%Y"
Time::DATE_FORMATS[:time_only] = "%I:%M%P"

# Initialize the Rails application.
Rails.application.initialize!
