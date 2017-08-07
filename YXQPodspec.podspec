
Pod::Spec.new do |s|

  s.name         = "YXQPodspec"
  s.version      = "1.3.2"
  s.summary      = "Methods used on iOS."
  s.description  = <<-DESC
                   It is methods used on iOS.
                   DESC
  s.homepage     = "https://github.com/15910507033/YXQPodspec"
  s.license      = 'MIT'
  s.author             = { "15910507033" => "15910507033@163.com" }
  s.source       = { :git => "https://github.com/15910507033/YXQPodspec.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files  = 'YXQPodspec/*'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit', 'Security', 'AdSupport', 'SystemConfiguration'
  s.dependency 'OpenUDID'
  s.dependency 'MJRefresh'
  s.dependency 'SDWebImage'
  s.dependency 'RegexKitLite'
  s.dependency 'AFNetworking'
  s.dependency 'RSAEncryptor'
  s.dependency 'SBJson', '2.2.3'
  s.dependency 'JSONModel', '1.0.2'

end