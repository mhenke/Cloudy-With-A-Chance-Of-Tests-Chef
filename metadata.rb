name             "mxunit"
maintainer       "NATHAN MISCHE"
maintainer_email "nmische@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures MXUnit"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

%w{ centos redhat ubuntu }.each do |os|
  supports os
end

depends "coldfusion10"

recipe "mxunit", "Installs MXUnit and adds a ColdFusion mapping."
