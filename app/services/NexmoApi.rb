require 'net/http'
require 'base64'
require 'json'
require 'ostruct'
require 'openssl'


class NexmoApi


  def self.balance(api_key, api_secret)
    uri = URI("https://rest.nexmo.com/account/get-balance?api_key=#{api_key}&api_secret=#{api_secret}")
    request = Net::HTTP::Get.new(uri)
    request['Content-type'] = 'application/json'
    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    return nil unless response.is_a?(Net::HTTPSuccess)
    balance = JSON.parse(response.body, object_class: OpenStruct)
    return balance.value
  end

  def self.apps(api_key, api_secret)
    uri = URI('https://api.nexmo.com/v2/applications')
    request = Net::HTTP::Get.new(uri)
    auth = "Basic " + Base64.strict_encode64("#{api_key}:#{api_secret}")
    request['Authorization'] = auth
    request['Content-type'] = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    return nil unless response.is_a?(Net::HTTPSuccess)
    json_object = JSON.parse(response.body, object_class: OpenStruct)
    return json_object._embedded.applications
  end


  def self.app_create(nexmo_app, api_key, api_secret)
    uri = URI('https://api.nexmo.com/v2/applications/')
    request = Net::HTTP::Post.new(uri)
    auth = "Basic " + Base64.strict_encode64("#{api_key}:#{api_secret}")
    request['Authorization'] = auth
    request['Content-type'] = 'application/json'
    request.body = {
      name: nexmo_app.name, 
      keys: {
        public_key: nexmo_app.public_key
      },
      capabilities: {
        messages: {
          webhooks: {
            inbound_url: {
              address: nexmo_app.inbound_url,
              http_method: nexmo_app.inbound_url_method
            },
            status_url: {
              address: nexmo_app.status_url,
              http_method: nexmo_app.status_url_method
            }
          }
        }
      }
    }.to_json
    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    unless response.is_a?(Net::HTTPSuccess)
      puts "ERROR"
      puts response.body
      return false
    end

    jsonApp = JSON.parse(response.body, object_class: OpenStruct)
    nexmo_app.update(app_id: jsonApp.id)
    return true
  end


  def self.app_update(nexmo_app, api_key, api_secret)
    uri = URI('https://api.nexmo.com/v2/applications/' + nexmo_app.app_id)
    request = Net::HTTP::Put.new(uri)
    auth = "Basic " + Base64.strict_encode64("#{api_key}:#{api_secret}")
    request['Authorization'] = auth
    request['Content-type'] = 'application/json'
    request.body = {
      name: nexmo_app.name, 
      keys: {
        public_key: nexmo_app.public_key
      },
      capabilities: {
        messages: {
          webhooks: {
            inbound_url: {
              address: nexmo_app.inbound_url,
              http_method: nexmo_app.inbound_url_method
            },
            status_url: {
              address: nexmo_app.status_url,
              http_method: nexmo_app.status_url_method
            }
          }
        }
      }
    }.to_json
    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    unless response.is_a?(Net::HTTPSuccess)
      puts "ERROR"
      puts response.code
      puts response.body
      return false
    end

    jsonApp = JSON.parse(response.body, object_class: OpenStruct)
    nexmo_app.update(app_id: jsonApp.id)
    return true
  end

  



  def self.numbers(api_key, api_secret)
    uri = URI("https://rest.nexmo.com/account/numbers?api_key=#{api_key}&api_secret=#{api_secret}&size=100")
    request = Net::HTTP::Get.new(uri)
    request['Content-type'] = 'application/json'
    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    return [] unless response.is_a?(Net::HTTPSuccess)
    json_object = JSON.parse(response.body, object_class: OpenStruct)
    return json_object.numbers || []
  end

  def self.unassigned_numbers(api_key, api_secret)
    uri = URI("https://rest.nexmo.com/account/numbers?api_key=#{api_key}&api_secret=#{api_secret}&has_application=false&size=100")
    request = Net::HTTP::Get.new(uri)
    request['Content-type'] = 'application/json'
    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    return [] unless response.is_a?(Net::HTTPSuccess)
    json_object = JSON.parse(response.body, object_class: OpenStruct)
    return json_object.numbers || []
  end


  def self.number_search(country, api_key, api_secret)
    uri = URI("https://rest.nexmo.com/number/search?api_key=#{api_key}&api_secret=#{api_secret}&country=#{country}&features=SMS&size=20")
    request = Net::HTTP::Get.new(uri)
    request['Content-type'] = 'application/json'
    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    return nil unless response.is_a?(Net::HTTPSuccess)
    json_object = JSON.parse(response.body, object_class: OpenStruct)
    return json_object.numbers
  end

  def self.number_buy(country, msisdn, api_key, api_secret)
    uri = URI("https://rest.nexmo.com/number/buy?api_key=#{api_key}&api_secret=#{api_secret}")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data({
      country: country,
      msisdn: msisdn
    })
    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    return response.is_a?(Net::HTTPSuccess)
  end

  
  def self.number_add(app_id, country, msisdn, api_key, api_secret)
    uri = URI("https://rest.nexmo.com/number/update?api_key=#{api_key}&api_secret=#{api_secret}")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data({
      country: country,
      msisdn: msisdn,
      messagesCallbackType: "app",
      messagesCallbackValue: app_id
    })
    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    return response.is_a?(Net::HTTPSuccess)
  end


  def self.number_remove(app_id, country, msisdn, api_key, api_secret)
    uri = URI("https://rest.nexmo.com/number/update?api_key=#{api_key}&api_secret=#{api_secret}")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data({
      country: country,
      msisdn: msisdn,
      messagesCallbackType: "app"
    })
    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    return response.is_a?(Net::HTTPSuccess)
  end


  def self.generate_admin_jwt(nexmo_app)
    return if nexmo_app.private_key.blank?
    rsa_private = OpenSSL::PKey::RSA.new(nexmo_app.private_key)
    payload = {
      "application_id": nexmo_app.app_id,
      "iat": Time.now.to_i,
      "jti": SecureRandom.uuid,
      "exp": (Time.now.to_i + 86400),
    }
    token = JWT.encode payload, rsa_private, 'RS256'
    return token
  end




  ###################################
  ######## EXTERNAL ACCOUNTS ########
  ###################################


  def self.external_accounts(nexmo_app)
    return [] if nexmo_app.private_key.blank?

    uri = URI('https://api.nexmo.com/beta/chatapp-accounts/')
    request = Net::HTTP::Get.new(uri)
    auth = "Bearer " + generate_admin_jwt(nexmo_app)
    request['Authorization'] = auth
    request['Content-type'] = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    puts "RESPONSE - external_accounts"
    puts "Status: #{response.code}"
    puts "Body:"
    puts response.body
    puts "--- RESPONSE - external_accounts."
    return [] unless response.is_a?(Net::HTTPSuccess)
    apps = JSON.parse(response.body, object_class: OpenStruct)
    return apps
  end


  def self.external_accounts_add(nexmo_app, provider, external_id)
    #https://api.nexmo.com/beta/chatapp-accounts/:provider/:external_id/applications
    uri = URI("https://api.nexmo.com/beta/chatapp-accounts/#{provider}")
    request = Net::HTTP::Post.new(uri)
    token = generate_admin_jwt(nexmo_app)
    auth = "Bearer " + token
    request['Authorization'] = auth
    request['Content-type'] = 'application/json'
    request.body = {
      # # name: "Test page load",
      # # external_id: external_id,
      # application: nexmo_app.app_id
      # # access_token: token
      # access_token: "EAAZAHOZAerQZBoBAFSlJFxl5wlI0us0IlNZAOeejzJbTlJDlPrXSASTc66SJyOGwLIin3xZAJNKFZAtaiuA79HSjDjZArp62S6f0OVlWgRGHHLbDe1srvskOZARk7XZAHJV2pNyOy8mjFONZBhWoZAcDKQ0QaDRRpOKZCA4dIGRpBOQlrE932hE5um4sWwFQ85drZCHSRB4AwhDNCiQZDZD",
      access_token: "EAAZAHOZAerQZBoBAHbI5uJkjSad6THBOarHBhowYdAzLTlQvO02BZBTVAZAgWcEzYERy4wbwPypRTR1kym6YlSMbfYDNRFZCl2fgUjcR3zTvZC7sCRZCJrSJwBYIUuS8EaFIK33ekzrivyAcZBQf2bDDlazZCaTMSqAg7zhmUWPNt0yMkPKDfAKIZCMHVG1nbTDSQGPivOSw0JGDKBgtdw0G1OQS2dKaqYkoZBkZD",
      external_id: external_id,
      name: "Paul Vonage 2 linked"
    }.to_json
    puts "REQUEST - account add"
    puts "URI: " + uri.to_s
    puts "Body:"
    puts request.body
    puts "--- REQUEST - account add."

    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    puts "RESPONSE - account add"
    puts "Status: #{response.code}"
    puts "Body:"
    puts response.body
    puts "--- RESPONSE - account add."
    return response.is_a?(Net::HTTPSuccess)
  end


  def self.external_accounts_remove(nexmo_app, provider, external_id)
    # https://api.nexmo.com/beta/chatapp-accounts/:provider/:external_id/applications/:application_id
    uri = URI("https://api.nexmo.com/beta/chatapp-accounts/#{provider}/#{external_id}")
    puts "external_accounts_remove: " + uri.to_s
    request = Net::HTTP::Delete.new(uri)
    auth = "Bearer " + generate_admin_jwt(nexmo_app)
    request['Authorization'] = auth
    request['Content-type'] = 'application/json'

    puts "REQUEST - account remove"
    puts "URI: " + uri.to_s
    puts "Body:"
    puts request.body
    puts "--- REQUEST - account remove."

    response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(request)
    }
    puts "RESPONSE - account remove"
    puts "Status: #{response.code}"
    puts "Body:"
    puts response.body
    puts "--- RESPONSE - account remove."
    return response.is_a?(Net::HTTPSuccess)
  end


end