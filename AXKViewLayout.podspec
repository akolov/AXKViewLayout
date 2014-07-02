Pod::Spec.new do |s|
  s.name         = 'AXKViewLayout'
  s.version      = '1.0.3'
  s.license      = 'MIT'
  s.summary      = 'Category to simplyfy working with autolayout.'
  s.author       = { 'Alexander Kolov' => 'me@alexkolov.com' }
  s.source       = { :git => 'https://github.com/silverity/AXKViewLayout.git', :tag => "#{s.version}" }
  s.homepage     = 'https://github.com/silverity/AXKViewLayout'
  s.platform     = :ios
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes'
  s.frameworks   = 'UIKit'
end
