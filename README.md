# NikePlus

A Ruby library for accessing Nike+ data.

## Installation
  gem install nike_plus

## Documentation
  [http://rdoc.info/gems/nike_plus][documentation]
  
  [documentation]: http://rdoc.info/gems/nike_plus

## Usage Example
    nike = NikePlus::Client.new( :email => 'test@nikeplus.com', :password => 'mypassword' )
  
    list = nike.activities
    
    list.each do |summary|
      activity = nike.activity( summary.activityId )

      puts "name      : #{ activity.name }"
      puts "distance  : #{ activity.miles } miles"
      puts "pace      : #{ activity.mpm } min/mile"
      puts "waypoints : #{ activity.geo.waypoints.size } points" if activity.geo.waypoints.any?
    end
    
## Contributing
In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by fixing [issues][]
* by reviewing patches

[issues]: https://github.com/aroth/nike_plus/issues
   
## Copyright
Copyright (c) 2012 Adam Roth
See [LICENSE][] for details.

[license]: https://github.com/aroth/nike_plus/blob/master/LICENSE.txt