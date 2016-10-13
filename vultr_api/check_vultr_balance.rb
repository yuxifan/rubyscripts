# gem install faraday
# gem install json
# gem install gmail

require 'faraday'
require 'json'
require 'gmail'

conn = Faraday.new(:url => 'https://api.vultr.com') do |c|
  c.use Faraday::Request::UrlEncoded
  c.use Faraday::Adapter::NetHttp
end
response = conn.get do |req|
  req.url '/v1/account/info'
  req.headers['API-Key'] = 'your API key'
end
responseStr  = response.body
responseJson = JSON.parse(responseStr)
balance = responseJson['balance']
pending_charges = responseJson['pending_charges']

user = "your gmail"
pass = "your gmail password"
gmail = Gmail.connect(user, pass)
email = gmail.compose do
  to "the email address receiving reports"
  subject "Your Vultr balance"
  body "Balance: " + balance + "\n" + "Pending charges: " + pending_charges
end
email.deliver!
