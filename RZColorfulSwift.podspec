#
# Be sure to run `pod lib lint RZColorfulSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RZColorfulSwift'
  s.version          = '0.3.0'
  s.summary          = 'NSAttributedString富文本的快捷设置方法集合,以及UITextView、UITextField、UILabel富文本简单优雅的使用'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description  = <<-DESC
  富文本方法集合，使用链式的方法快速简单的使用富文本NSAttributedString的功能
  变更使用方法名xxx.rz_xxx()为xxx.rz.xxx()
                 DESC

  s.homepage         = 'https://github.com/rztime/RZColorfulSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rztime' => 'rztime@vip.qq.com' }
  s.source           = { :git => 'https://github.com/rztime/RZColorfulSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_versions = ['4.2', '5.0']
  s.ios.deployment_target = '8.0'
  #s.osx.deployment_target = '10.9'
  #s.tvos.deployment_target = '9.0'
  #s.platform     = "8.0"

  s.source_files = 'RZColorfulSwift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RZColorfulSwift' => ['RZColorfulSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
