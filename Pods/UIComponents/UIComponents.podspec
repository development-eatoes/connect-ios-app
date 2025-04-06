Pod::Spec.new do |s|
  s.name             = 'UIComponents'
  s.version          = '0.1.0'
  s.summary          = 'UI Components for Connect app'
  s.description      = 'Reusable UI components and views for the Connect iOS app'
  s.homepage         = 'https://github.com/development-eatoes/connect-ios-app'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Connect Team' => 'info@connect.example.com' }
  s.source           = { :git => 'https://github.com/development-eatoes/connect-ios-app.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.swift_version = '5.0'
  s.source_files = 'UIComponents/Classes/**/*'
  
  # Dependencies
  s.frameworks = 'SwiftUI'
end
