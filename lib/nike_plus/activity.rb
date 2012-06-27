module NikePlus
  # Nike+ returns a lot of data for an activity. Internally, Hashie is used to convert the parsed JSON data 
  # into a pseduo-hash that behaves like an object. Below is a fairly complete list of the data returned for
  # an activity logged with Nike+ in June 2012:
  #  
  #              name => "RUN ON: 06/21/12 06:28 PM",
  #        activityId => "2003132748",
  #      activityType => "RUN",
  #          timeZone => "-04:00",
  #        timeZoneId => "GMT-04:00",
  #         dstOffset => "00:00",
  #      startTimeUtc => "2012-06-21T18:28:45-04:00",
  #            status => "complete",
  #        activeTime => 0,
  #               gps => true,
  #          latitude => 41.765266,
  #         longitude => -72.66858,
  #         heartrate => false,
  #        deviceType => "IPHONE",
  #            prevId => "2000841465",
  #          duration => 2140619,
  #          calories => 393,
  #              fuel => 1320,
  #             steps => 0,
  #          distance => 6.240550994873047,
  #  averageHeartRate => 0.0,
  #  minimumHeartRate => 0.0,
  #  maximumHeartRate => 0.0,
  #        isTopRoute => false,
  #          syncDate => 1340320046000,
  #         snapshots => { ... },
  #               geo => { 
  #                         coordinate => "41.762526, -72.66285",
  #                          waypoints => [ ... ] 
  #                      },
  #           history => [ ... ]
  #
  #
  # Usage:
  #   activity = nike.activity( 1000001 )
  #
  #   activity.name           # => "RUN ON: 06/21/12 06:28 PM"
  #   activity.deviceType     # => "IPHONE"
  #
  #   points = activity.geo.waypoints
  #   points[0].lat           # => 41.75566
  #   points[0].lon           # => -72.6529
  #   points[0].ele           # => 10.86276
  #
  # It's a good idea to inspect the Activity object to determine exactly what data you may want. 
  #
  # Instance methods defined below manipulate this data into more useful forms.
  
  class Activity < Hashie::Mash
    
    KM_TO_MILE = 0.621371192
    
    # Return an array of waypoints in the form:  [ [lat, lon], [lat, lon], [lat, lon] ]
    def waypoint_list
      return [] unless self.geo and self.geo.waypoints
      self.geo.waypoints.collect { |waypoint| [waypoint.lat, waypoint.lon] }
    end
    
    # Return activity duration in the form HH:MM:SS. 
    def time
      a=[1, 1000, 60000, 3600000]*2
      ms = duration
      "%02d" % (ms / a[3]).to_s << ":" << 
      "%02d" % (ms % a[3] / a[2]).to_s << ":" << 
      "%02d" % (ms % a[2] / a[1]).to_s #<< "." << 
      #"%03d" % (ms % a[1]).to_s
    end
    
    ## Activity distance in kilometers.
    def kilometers
      self.distance
    end
    
    ## Activity distance in miles.
    def miles
      self.distance * KM_TO_MILE
    end

    ## Activity speed in kilometers per hour.
    def kmh
      values = self.speed_values
      return nil unless values and values.any?
      
      avg = sum = 0.0
      values.each { |value| sum += value.to_f }
      avg = sum / values.size
    end

    ## Activity speed in miles per hour.
    def mph
      return nil unless self.kmh
      self.kmh * KM_TO_MILE
    end
    
    ## Activity pace in minutes per kilometer.
    def mpk
      kmh = self.kmh
      return nil unless kmh and kmh.is_a?(Float)
      div = 60.0 / kmh
      min = div.floor
      sec = ( ( div - min ) * 60.0 ).round 
      "#{ sprintf("%.2d", min ) }:#{ sprintf("%.2d", sec ) }"
    end

    ## Activity pace in minutes per mile.
    def mpm
      mph = self.mph
      return nil unless mph and mph.is_a?(Float)
      div = 60.0 / mph
      min = div.floor
      sec = ( ( div - min ) * 60.0 )
      "#{ sprintf("%.2d", min ) }:#{ sprintf("%.2d", sec ) }"
    end
  
    private
    
    def speed_values
      return nil unless self.history
      values = []
      self.history.each do |data|
        values = data['values'] if data.type == 'SPEED'
      end
      values
    end

  end
end