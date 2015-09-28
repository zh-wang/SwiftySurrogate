#
# Be sure to run `pod lib lint SwiftySurrogate.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftySurrogate"
  s.version          = "1.0.3"
  s.summary          = "Use UTF16 surrogate easier in Swift"
  s.homepage         = "https://github.com/zh-wang/SwiftySurrogate"
  s.license          = 'MIT'
  s.author           = { "zh-wang" => "viennakanon@gmail.com" }
  s.source           = { :git => "https://github.com/zh-wang/SwiftySurrogate.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/viennakanon'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*.{swift}'
end
