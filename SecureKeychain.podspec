#
# Be sure to run `pod lib lint SecureKeychain.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SecureKeychain'
  s.version          = '0.1.0'
  s.summary          = 'Simple wrapper for securing your keychain'

  s.homepage         = 'https://www.dashdevs.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dashdevs llc' => 'hello@dashdevs.com' }
  s.source           = { :git => 'https://bitbucket.org/itomych/securekeychain.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'

  s.source_files = 'Sources/SecureKeychain/**/*'
end
