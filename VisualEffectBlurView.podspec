
Pod::Spec.new do |s|
  s.name             = 'VisualEffectBlurView'
  s.version          = '6.2.0'
  s.summary          = 'UIVisualEffectView blur w/ custom blur radius.'

  s.description      = <<-DESC
    A subclass of `UIVisualEffectView` that lets you set a custom blur radius
    + intensity.
  DESC

  s.homepage         = 'https://github.com/dominicstop/VisualEffectBlurView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dominic Go' => 'dominic@dominicgo.dev' }
  s.source           = { :git => 'https://github.com/dominicstop/VisualEffectBlurView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/GoDominic'

  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/**/*'
  s.frameworks = 'UIKit'
  
  s.dependency 'DGSwiftUtilities', '~> 0.37'
end
