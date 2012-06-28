require 'nike_plus/version'
require 'nike_plus/activity'
require 'nike_plus/activity_summary'

module NikePlus
  class Client

    attr_reader :screenname, :user, :authorization_response

    # Initializes a new NikePlus::Client object.
    #
    # Configuration options are:
    # * +email+ - Nike+ account email address.
    # * +password+ - Nike+ account password.
    # * +debug+- Debug flag, set to true for debugging output.
    #
    # Example:
    #   nike = NikePlus::Client.new( :email => 'test@nikeplus.com', :password => 'mypassword' )
    def initialize( options={} )
      @email = options[:email]
      @password = options[:password]
      @debug = options[:debug] 
      
      @agent = Mechanize.new

      url = 'https://secure-nikeplus.nike.com/nsl/services/user/login?app=b31990e7-8583-4251-808f-9dc67b40f5d2&format=json&contentType=plaintext'
      @authorization_response = post(url, { :email => @email, :password => @password })

      if @authorization_response.serviceResponse.header.success == 'true'
        @user = @authorization_response.serviceResponse.body.User
        @screenname = @user.screenName
      else
        raise @authorization_response.serviceResponse.header.errorCodes.first.message
      end
    end

    # Return an array of NikePlus::ActivitySummary objects. To retrieve full details on the activity use the #activity method.
    #
    # Example:
    #   activities = nike.activities # => [NikePlus::ActivitySummary, NikePlus::ActivitySummary]
    #   activity = nike.activity( activities[0].activityId ) # => NikePlus::Activity
    def activities
      url = "http://nikeplus.nike.com/plus/activity/running/#{ @screenname }/lifetime/activities?indexStart=0&indexEnd=9999"
      data = get(url)
      activity_list = data.activities.any? ? data.activities.collect { |a| NikePlus::ActivitySummary.new( a.activity ) } : []
    end

    # Return full details on a specific activity.
    #
    # Params:
    # * +id+ - Nike+ Activity ID
    #
    # Example:
    #   nike.activity( 123456 ) # => NikePlus::Activity
    def activity( id )
      url = "http://nikeplus.nike.com/plus/running/ajax/#{ id }"
      data = get(url)
      activity = NikePlus::Activity.new( data.activity ) if data.activity
    end

    # Return an array of activity ids.
    #
    # Example:
    #  nike.activity_ids # => [100, 101, 102, 103]
    def activity_ids
      self.activities.collect(&:activityId)
    end
        
    private
    
    def get( path )
      response = @agent.get( path )
      parse( response )
    end
    
    def post( path, params )
      response = @agent.post( path, params )
      parse( response )
    end
    
    def parse( response )
      hash = Hashie::Mash.new()
      begin
        json = JSON.parse( response.body )
        hash = Hashie::Mash.new( json )
      rescue
        warn "[ERROR] #{ $! }" if @debug
      end
      hash
    end
  
  end
  
end