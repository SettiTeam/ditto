Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "Ditto"
s.summary = "Layouts for all the devices."
s.requires_arc = true
s.version = "0.3"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Chase McClure" => "chase@curiosity.com" }
s.homepage = "https://github.com/Curiosity/Ditto"
s.source = { :git => "https://github.com/Curiosity/Ditto.git", :tag => "#{s.version}"}
s.framework = "UIKit"
s.source_files = "Ditto/**/*.{swift}"
end
