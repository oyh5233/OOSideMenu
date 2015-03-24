Pod::Spec.new do |s|
  s.name         = "OOSideMenu"
  s.version      = "0.0.1"
  s.summary      = "a side menu,easy to use and custom."
  s.ios.deployment_target = "7.0"
  s.homepage     = "https://github.com/oyh5233/OOSideMenu"
  s.license     = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "oyh5233" => "oyh5233@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/oyh5233/OOSideMenu.git", :tag =>s.version.to_s}
  s.source_files  = “OOSideMenu/Classes"
  s.public_header_files = "OOSideMenu/Classes/*.h"
  s.framework  = "QuartzCore"
  s.requires_arc = true
end
