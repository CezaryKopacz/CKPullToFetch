Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "CKPullToLoad"
s.summary = "Pull to load more content"
s.requires_arc = true

s.version = "0.1.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Cezary Kopacz" => "cezary@ckopacz.pl" }

s.homepage = "https://github.com/CezaryKopacz/CKPullToLoad"

s.source = { :git => "https://github.com/CezaryKopacz/CKPullToLoad.git",
:tag => "#{s.version}" }

s.framework = "UIKit"

s.source_files = "CKPullToLoad/**/*.{swift}"

s.resources = "CKPullToLoad/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

s.swift_version = "4.2"

end

