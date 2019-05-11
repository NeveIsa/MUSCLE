require_relative 'app'



use Rack::Static, :urls => ["/public"]
run Sinatra::Application
