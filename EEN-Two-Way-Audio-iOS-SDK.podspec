#
# Be sure to run `pod lib lint EEN-Two-Way-Audio-iOS-SDK.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'EEN-Two-Way-Audio-iOS-SDK'
  s.version          = '1.0.0'
  s.summary          = 'A WEBRTC Two Way audio solution designed specifically to stream from/to EagleEye Networks.'
  s.description      = 'A WEBRTC Two Way audio solution designed specifically to stream from/to EagleEye Networks.'
  s.homepage         = 'https://github.com/EENCloud/EEN-Two-Way-Audio-iOS-SDK'
  s.author           = { 'Suhaib Al Saghir' => 'salsaghir@een.com' }
  s.ios.deployment_target = '13.0'
  s.vendored_frameworks = 'EEN_Two_Way_Audio_iOS_SDK.xcframework'
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.license = { 
    :type => 'Proprietary', 
    :text => 'This binary is is not openly licensed to any individual without prior written permission and remains the property of EagleEye Networks, Inc.' 
  }

  s.source = {
    :http => 'https://github.com/EENCloud/EEN-Two-Way-Audio-iOS-SDK/blob/main/EEN_Two_Way_Audio_iOS_SDK.zip?raw=true'
  }
end