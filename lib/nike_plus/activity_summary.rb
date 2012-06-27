module NikePlus
  # Calling NikePlus#activites returns an array of ActivitySummary objects.  ActivitySummary data does
  # not include geographic or historical details (waypoints, speed, pacing intervals). Use NikePlus#activity to
  # retrieve those. Below is a fairly complete list of the summary data returned for an activity logged 
  # with Nike+ in June 2012:
  #
  #                name => "RUN ON: 06/21/12 06:28 PM",
  #          activityId => "2003132748",
  #        activityType => "RUN",
  #            timeZone => "-04:00",
  #          timeZoneId => "GMT-04:00",
  #           dstOffset => "00:00",
  #        startTimeUtc => "2012-06-21T18:28:45-04:00",
  #              status => "complete",
  #          activeTime => 0,
  #                 gps => true,
  #            latitude => 41.765266,
  #           longitude => -72.66858,
  #           heartrate => false,
  #          deviceType => "IPHONE",
  #          isTopRoute => false,
  #                tags => {
  #                           location => "outdoors",
  #                           emotion  => "amped",
  #                           weather  => "amped",
  #                           terrain  => "amped"
  #                        },
  #             metrics => {
  #                            averageHeartRate => 0.0,
  #                            minimumHeartRate => 0.0,
  #                            maximumHeartRate => 0.0,
  #                            averagePace => 343017.62805217603,
  #                            duration => 2140619,
  #                            calories => 393,
  #                            fuel => 1320,
  #                            steps => 0,
  #                            distance => 6.240550994873047
  #                          }
  #
  # Usage:
  #   # Summary
  #   summary = nike.activities.first               # => NikePlus::ActivitySummary
  #   summary.name                                  # => "RUN ON: 06/21/12 06:28 PM"
  #   summary.metrics.calories                      # => 393
  #
  #   # Full details
  #   activity = nike.activity( summary.activityId ) # => NikePlus::Activity
  #   activity.geo.waypoints
  #   activity.geo.mph 
  #
  # The fields above not gauranteed. For example, activities logged prior to the Nike+GPS app do not
  # return GPS or tag data. It's a good idea to inspect the ActivitySummary object to determine exactly what data 
  # you may want. 
                    
  class ActivitySummary < Hashie::Mash
  end
end