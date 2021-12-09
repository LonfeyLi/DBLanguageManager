#
# Be sure to run `pod lib lint DBLanguageManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'DBLanguageManager'
s.version          = '1.0.6'
s.summary          = 'a management tool of iOS project language configuration'
s.description      = <<-DESC
TODO: iOS国际化配置工具
DESC

s.homepage         = 'https://github.com/LonfeyLi/DBLanguageManager'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'LonfeyLi' => 'lonfey6@163.com' }
s.source           = { :git => 'https://github.com/LonfeyLi/DBLanguageManager.git', :tag => s.version.to_s }
s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
s.ios.deployment_target = '9.0'
s.requires_arc = true
s.source_files = 'DBLanguageManager/Classes/**/*{.h,.m}'
end
