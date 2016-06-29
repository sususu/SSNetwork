#
# Be sure to run `pod lib lint SSNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SSNetwork'
  s.version          = '0.1.2'
  s.summary          = 'a wrapper for AFNetworking, easy to use'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
long description, what should i write? long description, what should i write? long description, what should i write? long description, what should i write? long description, what should i write? long description, what should i write? long description, what should i write? long description, what should i write?
long enough?
                       DESC

  s.homepage         = 'https://github.com/sususu/SSNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sujiang' => 'sujiangbest@163.com' }
  s.source           = { :git => 'https://github.com/sususu/SSNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/sunima0318'

  s.ios.deployment_target = '7.0'

  s.source_files = 'SSNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SSNetwork' => ['SSNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'AFNetworking'
end
