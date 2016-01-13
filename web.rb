require 'sinatra'

get '/*' do
  redirect 'http://12factor.net/ja/' + params['splat'].first, 301
end
