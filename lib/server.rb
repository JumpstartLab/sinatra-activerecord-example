require 'sinatra'
require 'sinatra/activerecord'
require 'json'

require 'url'

ENV['DATABASE_URL'] ||= "sqlite3:///database.sqlite"

class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :database, ENV['DATABASE_URL']

  get "/" do
    erb :home
  end

  get '/shorten_test' do
    Url.create original: "http://jumpstartlab.com", shortened: "js"
  end

  post "/register" do
    clear_password = params[:password]

    salt = "SALT"
    password_signer = Digest::HMAC.new(salt,Digest::SHA1)

    salted_password = password_signer.hexdigest(clear_password)

    puts "Password: #{salted_password} salted with love by #{salt}"

    # Store the password and the salt to the database

    redirect to "/"

  end

  def find_salt_and_salted_password_for_user(username)
    [ "SALT", "6adc7563bc0cc08f111ee30e86e23712b1022361" ]
  end

  post "/login" do
    clear_password = params[:password]
    username = params[:username]

    # find the user in the database and get their salt and salted password
    salt, salted_password = find_salt_and_salted_password_for_user(username)


    password_verifier = Digest::HMAC.new(salt,Digest::SHA1)
    resulting_password = password_verifier.hexdigest(clear_password)

    if salted_password == resulting_password
      redirect to "/success"
    else
      redirect to "/failure"
    end

  end

  get "/success" do
    "SUCCESS"
  end

  get "/failure" do
    "FAILURE"
  end


  post "/shorten" do
    puts "Params: #{params}"

    if valid_shorten_request?(params[:signature],params[:url])
      { url: "SHORTENED URL" }.to_json
    else
      { error: "I don't know who you are anymore!" }.to_json
    end
  end

  def valid_shorten_request?(signature,url)
    api_key = "API_KEY2"
    signer = Digest::HMAC.new(api_key,Digest::SHA1)

    # signer needs to look at url and generate a signature
    resulting_signature = signer.hexdigest(url)
    puts "Signature: #{signature}"
    puts "Resulting: #{resulting_signature}"
    signature == resulting_signature
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
