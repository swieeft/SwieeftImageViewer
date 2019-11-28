Pod::Spec.new do |s|
  s.name             = 'SwieeftImageViewer'
  s.version          = '1.0.0'
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
  s.source           = { :git => 'https://github.com/swieeft/SwieeftImageViewer.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.2'
  s.source_files = 'Classes/*.swift'
end
