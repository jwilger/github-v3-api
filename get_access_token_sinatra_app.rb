require 'rubygems'
require 'bundler/setup'
Bundler.setup(:sinatra)
require 'sinatra'
require 'openssl'
require 'omniauth'

# Because fuck you, Apple
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

enable :sessions

use OmniAuth::Builder do
  provider :github, 'f96475ae5e9db9168299', '1f688051529f1c0e470946870ea0fbbdacb68f19',
    :scope => 'user,repo,gist'
end

get '/' do
  redirect '/auth/github'
end

get '/auth/github/callback' do
  token = request.env['omniauth.auth']['credentials']['token']
  "Your GitHub Access Token is #{token}"
end
