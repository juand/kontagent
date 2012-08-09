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
      path = "/api/v1/#{api_key}/#{MESSAGES_TYPES[:application_installed]}/?s=#{user_id}"
      path += "&u=#{opts[:unique_tracking_tag]}" if opts[:unique_tracking_tag]
      path += "&su=#{opts[:short_tracking_tag]}" if opts[:short_tracking_tag]
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
      path += "&n=#{event_name}"
      path += "&v=#{opts[:value]}" if opts[:value]
      path += "&l=#{opts[:level_id]}" if opts[:level_id]
      path += "&st1=#{opts[:st1]}" if opts[:st1]
      path += "&st2=#{opts[:st2]}" if opts[:st2]
      path += "&st3=#{opts[:st3]}" if opts[:st3]
      call_api(path)
    end
    
    private
    def call_api(path)
      http = Net::HTTP.new(base_url)
      Kontagent.logger.debug "[#{Time.now.to_s}][Kontagent Request] #{base_url+path}" if debug_mode
      response = http.get(path)
      Kontagent.logger.debug "[#{Time.now.to_s}][Kontagent Response] #{response.code}: #{response.body}" if debug_mode
      response
    end
    
  end
end