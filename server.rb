require 'sinatra'
require 'sinatra/activerecord'

require './url'

ENV['DATABASE_URL'] ||= "sqlite3:///database.sqlite"

class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :database, ENV['DATABASE_URL']

  get "/" do
    "Home"
  end

  get '/shorten_test' do
    Url.create original: "http://jumpstartlab.com", shortened: "js"
  end

  get '/*' do
    requested_shortened_url = params[:splat].first

    url = Url.where(shortened: requested_shortened_url).first

    if url
      redirect to(url.original)
    else
      "I can see it in your eyes"
    end

  end

end
