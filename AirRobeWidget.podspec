Pod::Spec.new do |spec|
  spec.name          = "AirRobeWidget"
  spec.version       = ENV['LIB_VERSION'] || '1.1.0' # fallback to major version
  spec.summary       = "AirRobe iOS Widget SDK"
  spec.description   = <<-DESC
    The AirRobeWidget iOS SDK provides conveniences to make your AirRobeWidget integration experience as smooth and straightforward as possible. We`re working on crafting a great framework for developers with easy drop in components to integrate our widgets easy for your customers.
  DESC
  spec.homepage      = "https://github.com/airrobe/widget-sdk-ios"
  spec.license       = "Apache License, Version 2.0"
  spec.author        = "AirRobeWidget"
  spec.platform      = :ios, "13.0"
  spec.ios.deployment_target  = "13.0"
  spec.source        = { :git => "https://github.com/airrobe/widget-sdk-ios.git", :tag => "#{spec.version}" }
  spec.resources     = "Sources/AirRobeWidget/**/*.{pdf,xcassets,json}"
  spec.source_files  = "Sources/AirRobeWidget/**/*.{plist,swift}"
  spec.swift_version = "5"
  spec.framework     = "UIKit"
end
