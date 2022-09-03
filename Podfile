platform :ios, '14.0'
use_frameworks!

target 'SampleProject' do

  pod 'R.swift', '5.2.2'
  pod 'Shakuro.TaskManager'
  pod 'Shakuro.HTTPClient'
  pod 'Shakuro.CommonTypes'
  pod 'SwiftyJSON', '5.0.0'
  pod 'NVActivityIndicatorView', '5.1.1'
  pod 'SDWebImage', '5.10.4'
  pod 'Shakuro.iOS_Toolbox', :git => 'https://gitlab.com/shakuro-public/ios_toolbox.git', :commit => 'b447d2422d321098218095af47636fe12652230a'
  pod 'SwiftLint'
  pod 'ZoomImageView'

end

# Post Install "error: IB Designables: Failed to render and update auto layout ..." fix
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
    end

end
