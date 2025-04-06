Pod::Spec.new do |s|
  s.name             = 'NetworkLayer'
  s.version          = '0.1.0'
  s.summary          = 'Network layer for Connect app'
  s.description      = 'Network services, API endpoints, and data models for the Connect app'
  s.homepage         = 'https://github.com/development-eatoes/connect-ios-app'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Connect Team' => 'info@connect.example.com' }
  s.source           = { :git => 'https://github.com/development-eatoes/connect-ios-app.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.swift_version = '5.0'
  s.source_files = 'NetworkLayer/Classes/**/*'
  
  # Dependencies
  s.frameworks = 'Foundation', 'Combine'
end
