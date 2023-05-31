platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!

workspace 'CurrencyConverterChallenge'

def shared_pods
  pod 'SwiftLint'
  pod 'SkeletonView'
end

target 'CurrencyConverterChallenge' do
  project 'CurrencyConverterChallenge/CurrencyConverterChallenge.xcodeproj'
  shared_pods

  target 'CurrencyConverterChallengeTests' do
    inherit! :search_paths
    shared_pods
  end
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
