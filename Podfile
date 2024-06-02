# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'
workspace 'news-ios'

target 'news-ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for news-ios
  pod 'Moya'
  pod 'SDWebImage'
  pod 'SnapKit'
  pod 'IQKeyboardManager'
  pod 'lottie-ios'

  target 'news-iosTests' do
    inherit! :search_paths
    pod 'Moya'
    pod 'SDWebImage'
    pod 'SnapKit'
    pod 'IQKeyboardManager'
    pod 'lottie-ios'
  end

end

target 'Core' do
  
  project 'Modules/Core/Core'
  use_frameworks!
  
  pod 'Moya'
  pod 'SDWebImage'
  pod 'SnapKit'

  target 'CoreTests' do
    inherit! :search_paths
    pod 'Moya'
    pod 'SDWebImage'
    pod 'SnapKit'
  end
end

target 'News' do
  
  project 'Modules/News/News'
  use_frameworks!
  
  pod 'Moya'
  pod 'SDWebImage'
  pod 'SnapKit'

  target 'NewsTests' do
    inherit! :search_paths
    pod 'Moya'
    pod 'SDWebImage'
    pod 'SnapKit'
  end
end
