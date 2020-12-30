#
# Be sure to run `pod lib lint EmotionKeyboard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EmotionKeyboard'
  s.version          = '0.0.3'
  s.summary          = 'custom EmotionKeyboard '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
valid_archs = ['armv7s','arm64','armv7']
s.xcconfig = {
  'VALID_ARCHS' =>  valid_archs.join(' '),
}
s.pod_target_xcconfig = {
    'ARCHS[sdk=iphonesimulator*]' => '$(ARCHS_STANDARD_64_BIT)'
}
  s.description      = <<-DESC
表情键盘 使用见测试 
                       DESC

  s.homepage         = 'https://github.com/wokua/CHEmotionKeyboard'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1060566471@qq.com' => '1060566471@qq.com' }
  s.source           = { :git => 'https://github.com/wokua/CHEmotionKeyboard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'EmotionKeyboard/Classes/Emotion/**/*'
  
   s.resource_bundles = {
     'EmotionKeyboard' => ['EmotionKeyboard/Assets/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry'
end
