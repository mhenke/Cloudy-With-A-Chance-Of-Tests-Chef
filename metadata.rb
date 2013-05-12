name             "cloudy"
maintainer       "Mike Henke"
maintainer_email "henke.mike@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures Cloudy With A Chance Of Tests"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.42"

%w{ centos redhat ubuntu }.each do |os|
  supports os
end

depends "zip"

recipe "cloudy", "Installs Cloudy With A Chance Of Tests."