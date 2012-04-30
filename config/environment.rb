# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Hexedguild::Application.initialize!

# Making it work on HostGator
$.push("/home/sl36/ruby/gems")
ENV['GEM_PATH'] = '/home/sl36/ruby/gems:/usr/lib/ruby/gems/1.8'
