# Uncomment the next line to define a global platform for your project
  platform :ios, '9.0'

  source 'https://github.com/hao1234/Specs.git'

# Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
def baseapp_pods
    pod 'SnapKit', '~> 4.2'
    pod 'CocoaLumberjack/Swift', '~> 3.5.1'
    pod 'SwiftyJSON', '~> 4.2'
    pod 'ObjectMapper', '~> 3.4'
    pod 'SDWebImage', '4.4.5'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'Actions'
    
    # Internal pods'
    pod 'SwiftyLib', '~> 0.0.4'
    pod 'MLWebService', '~> 0.0.4'
end

target 'BaseNetworking' do
  baseapp_pods
end
