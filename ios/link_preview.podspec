#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'link_preview'
  s.version          = '0.0.1'
  s.summary          = 'Plugin for previewing links'
  s.description      = <<-DESC
Plugin for previewing links
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.dependency 'SwiftLinkPreview', '~> 3.0.1'

  s.ios.deployment_target = '8.0'
end

