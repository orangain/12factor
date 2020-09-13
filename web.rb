require 'sinatra'

get '/*' do
  redirect 'https://12factor.net/ja/' + params['splat'].first, 301
end
