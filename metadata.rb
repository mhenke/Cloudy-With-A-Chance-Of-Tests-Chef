name             "cloudy"
maintainer       "NATHAN MISCHE"
maintainer_email "nmische@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures cloudy"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ centos redhat ubuntu }.each do |os|
  supports os
end

depends "zip"
depends "ant"

recipe "cloudy", "Installs Cloudy With A Chance Of Tests."
