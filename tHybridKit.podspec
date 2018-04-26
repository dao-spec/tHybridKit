#
# Be sure to run `pod lib lint tHybridKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'tHybridKit'
  s.version          = '0.3.0'
  s.summary          = 'Native + Weex + H5'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                      Encapsulation For Native + Weex + H5
                       DESC

  s.homepage         = 'https://github.com/T0421/tHybridKit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dao' => 'cilike@sina.cn' }
  s.source           = { :git => 'https://github.com/T0421/tHybridKit.git', :tag => "v#{s.version.to_s}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform = :ios
  s.ios.deployment_target = '8.0'

  s.source_files = 'tHybridKit/**/**/*'

  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }

  # s.resource_bundles = {
  #   'tHybridKit' => ['tHybridKit/Assets/*.png']
  # }

  s.requires_arc = true

  s.public_header_files = 'tHybridKit/**/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'WeexSDK', '~> 0.16.2'
  s.dependency 'SDWebImage', '~> 4.2.2'
end
