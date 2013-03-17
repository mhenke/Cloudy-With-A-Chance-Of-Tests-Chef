original maintainer_email "nmische@gmail.com"
license          "Apache 2.0"
description      "Installs Cloudy With A Chance Of Tests"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ ubuntu }.each do |os|
  supports os
end

recipe "cloudy", "Installs Cloudy With A Chance Of Tests."