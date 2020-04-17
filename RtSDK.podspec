#
# Be sure to run `pod lib lint RtSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RtSDK'
  s.version          = '3.7.10'
  s.summary          = 'net263 RtSDK.'

  s.description      = <<-DESC
  net 263 RtSDK framework
                       DESC

  s.homepage         = 'https://github.com/net263/RtSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'net263' => '277715243@qq.com' }
  s.source           = { :git => 'https://github.com/net263/RtSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  s.vendored_frameworks = 'RtSDK.framework'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  s.resource = 'Resources/RtSDK.bundle'
  # s.resource_bundles = {
  #   'RtSDK' => ['RtSDK/Assets/*.png']
  # }
  s.static_framework = true
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'GLKit'
  s.dependency 'GSBaseKit','~> 3.7.10'
  # s.libraries = 'z', 'c++','iconv','icucore'
  # s.dependency 'AFNetworking', '~> 2.3'
end
