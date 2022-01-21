#
# Be sure to run `pod lib lint FZModuleKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FZModuleKit'
  s.version          = '0.0.1'
  s.summary          = '功能组件 FZModuleKit.'
  s.swift_version    = ['4.0', '4.2', '5.0']

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
提供一些功能组件，快速实现封装好的一些功能
                       DESC

  s.homepage         = 'https://github.com/dajiangjun887/FZModuleKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dajiangjun887' => 'jackjin@x2era.com' }
  s.source           = { :git => 'https://github.com/dajiangjun887/FZModuleKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'FZModuleKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FZModuleKit' => ['FZModuleKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'FZCommitKit'
  s.dependency 'SnapKit'
end
