Pod::Spec.new do |s|
  s.name             = 'SwieeftImageViewer'
  s.version          = '1.0.1'
  s.summary          = 'SwieeftImageViewer.'
  s.description      = <<-DESC
SwieeftImageViewer is a library that supports detailed image view like Facebook.
                       DESC
  s.homepage         = 'https://github.com/swieeft/SwieeftImageViewer'
  # s.screenshots      = 'https://magi82.github.io/images/2017-5-17-ios-regist-cocoapods/01.png',
  #                     'https://magi82.github.io/images/2017-5-17-ios-regist-cocoapods/02.png',
  #                     'https://magi82.github.io/images/2017-5-17-ios-regist-cocoapods/03.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'swieeft' => 'swieeft89@gmail.com' }
  s.source           = { :git => 'https://github.com/swieeft/SwieeftImageViewer.git', :tag => '1.0.1' }
  s.ios.deployment_target = '13.0'
  s.source_files = 'Classes/*.swift'
  s.swift_versions = '5.0'
end
