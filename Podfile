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
  pod 'IQKeyboardManagerSwift'
  pod 'lottie-ios'

  target 'news-iosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'news-iosUITests' do
    # Pods for testing
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
    # Pods for testing
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
    # Pods for testing
  end
end
