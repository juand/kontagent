require "kontagent"
require 'net/http'

module Kontagent
  module Tracking 
    extend self

    # Check for presence of all necessary data
    # @returns true/false accordingly
    def valid?
      !base_url.nil? && !api_key.nil?
    end

    # We only need user_id two other parameters are optional unless we want to track virality 
    # (unique_tracking_tag = invites, notifications, email or post)
    # (short_tracking_tag = ads, partner sites)
    # More details for usage of the params can be found here:    
    # http://developers.kontagent.com/getting-started/instrumenting-your-application/kontagent-rest-api/application-added
    #
    # @param [String] user_id      - id of the user
    # @param [String] unique_tracking_tag
    # @param [String] short_tracking_tag
    # 
    def notify_install(user_id, opts = {})    
      path = "/api/v1/#{api_key}/#{MESSAGES_TYPES[:application_installed]}/?s=#{user_id}&"
      path += opts.to_query
      call_api(path)
    end

    # We only need user_id 
    # More details for usage of the params can be found here:    
    # http://developers.kontagent.com/getting-started/instrumenting-your-application/kontagent-rest-api/application-uninstalled
    #
    # @param [String] user_id      - id of the user
    #  
    def notify_uninstall(user_id, opts = {})
      path = "/api/v1/#{api_key}/#{MESSAGES_TYPES[:application_uninstalled]}/?s=#{user_id}"
      call_api(path)
    end
    
    # We only need user_id 
    # More details for usage of the params can be found here:    
    # http://developers.kontagent.com/getting-started/instrumenting-your-application/kontagent-rest-api/application-uninstalled
    #
    # @param [String] user_id      - id of the user
    # @parma [String] ip           - IP for the user.
    #  
    def notify_location(user_id, ip)
      path = "/api/v1/#{api_key}/pgr/?s=#{user_id}"
      path += "&ip=#{ip}"
      call_api(path)
    end
    
    # This method allows us to track custom events 
    #
    # @see messages.rb for all the possible events or check the kontagent rest api
    # @see http://developers.kontagent.com/getting-started/instrumenting-your-application/kontagent-rest-api/events
    #
    # @param [String]  user_id     - id of the user
    # @param [String][opts]  b     - Birth Year
    # @param [String][opts]  g     - Gender
    # @param [String][opts]  lc    - Country
    # @param [String][opts]  ls    - State
    # @param [String][opts]  f     - Friend Count
    # @param [String][opts]  d     - Device Model
    #
    def notify_information(user_id, opts = {})
      path = "/api/v1/#{api_key}/#{MESSAGES_TYPES[:user_information]}/?s=#{user_id}"
      path += opts.to_query
      call_api(path)
    end
    
    # We only need user_id 
    # More details for usage of the params can be found here:    
    # http://developers.kontagent.com/getting-started/instrumenting-your-application/kontagent-rest-api/application-uninstalled
    #
    # @param [String] user_id      - id of the user
    # @param [integer] revenue      - IP for the user.
    # @param [transaction_type]
    #  
    def notify_revenue(user_id, revenue, transaction_type = nil, opts = {})
      path = "/api/v1/#{api_key}/mtu/?s=#{user_id}"
      path += "&v=#{revenue}"
      path += "&tu=#{transaction_type}"
      path += "&st1=#{opts[:st1]}" if opts[:st1]
      path += "&st2=#{opts[:st2]}" if opts[:st2]
      path += "&st3=#{opts[:st3]}" if opts[:st3]
      path += "&data=#{opts[:data]}" if opts[:data]
      call_api(path)
    end

    # This method allows us to track custom events 
    #
    # @see messages.rb for all the possible events or check the kontagent rest api
    # @see http://developers.kontagent.com/getting-started/instrumenting-your-application/kontagent-rest-api/events
    #
    # @param [String]  user_id     - id of the user
    # @param [String]  event_name           - name of the event
    # @parma [String]  value                - value of the event
    # @param [String]  level_id             - if of level (ie. for a game)
    # @param [String]  st1                  - subtype 1 
    # @param [String]  st2                  - subtype 2 
    # @param [String]  st3                  - subtype 3
    #
    def notify_event(user_id, event_name, opts = {})
      path = "/api/v1/#{api_key}/#{MESSAGES_TYPES[:custom_event]}/?s=#{user_id}"
      path += "&n=#{event_name}&"
      # path += "&v=#{opts[:value]}" if opts[:value]
      # path += "&l=#{opts[:level_id]}" if opts[:level_id]
      # path += "&st1=#{opts[:st1]}" if opts[:st1]
      # path += "&st2=#{opts[:st2]}" if opts[:st2]
      # path += "&st3=#{opts[:st3]}" if opts[:st3]
      path += opts.to_query
      call_api(path)
    end
    
    def set_call(type)
      @dial_out = Proc.new { |var| type ? secure_call_api(var) : simple_call_api(var) }
    end
    
    def process(url)
      @dial_out.call(url)
    end
    
    private
    
    def call_api(path)
      path += "&ts=#{Time.now.to_i}"
      if @delayed
        BackgroundInterface.enqueue_without_priority(Kontagent, 'process', path)
      else
        @dial_out.call(path)
      end
    end
    
    def simple_call_api(path)
      http = Net::HTTP.new(base_url)
      Kontagent.logger.debug "[#{Time.now.to_s}][Kontagent Request] #{base_url+path}" if debug_mode
      response = http.get(path)
      Kontagent.logger.debug "[#{Time.now.to_s}][Kontagent Response] #{response.code}: #{response.body}" if debug_mode
      response
    end
    
    def secure_call_api(path)
      uri = URI.parse('https://' + base_url)
      http = Net::HTTP.new uri.host, uri.port
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
      request = Net::HTTP::Get.new(path)
      
      Kontagent.logger.debug "[#{Time.now.to_s}][Kontagent Request] #{base_url+path}" if debug_mode
      response = http.request(request)
      Kontagent.logger.debug "[#{Time.now.to_s}][Kontagent Response] #{response.code}: #{response.body}" if debug_mode
      response
    end
  end
end