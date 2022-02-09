# AirRobeWidget

The AirRobeWidget iOS SDK provides conveniences to make your AirRobeWidget integration experience as smooth and straightforward as possible. We're working on crafting a great framework for developers with easy drop in components to integrate our widgets easy for your customers.

# Integration

## Requirements

- iOS 13.0+
- Swift 5.3+
- Xcode 12.0+


## Swift Package Manager (recommended)

This is the recommended integration method, but we assume that you already have the access to our Repo since its access is restricted for purposes.

```
dependencies: [
    .package(url: "https://github.com/airrobe/widget-sdk-ios.git", .upToNextMajor(from: "1.0.2"))
]
```


## Manual

Currently, we do not have any of other the supported dependency managers, so for now choose to manually integrate the AirRobe SDK into your project.

### Source

#### GitHub Release

Download the [latest release][latest-release] source zip from GitHub and unzip into an `AirRobeWidget` directory in the root of your working directory.

#### Git Submodule

We assume that you already have the access to our Repo since its access is restricted for purposes.
Add the AirRobeWidget SDK as a [git submodule][git-submodule] by navigating to the root of your working directory and running the following commands:

```
git submodule add https://github.com/airrobe/widget-sdk-ios.git AirRobeWidget
cd AirRobeWidget
git checkout 1.0.2
```

#### Project / Workspace Integration

Now that the AirRobeWidget SDK resides in the `AirRobeWidget` directory in the root of your working directory, it can be added to your project or workspace with the following steps:

1. Select your application project in the Project Navigator to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
2. In the tab bar at the top of that window, open the "General" panel.
3. Click on the `+` button under the "Frameworks, Libraries, and Embedded Content" section.
4. Select the `Workspace -> AirRobeWidget -> AirRobeWidget` for your target platform.

And that's it, the AirRobeWidget SDK is now ready to import and use within your application.

## TODOs: CocoaPods, Carthage - Coming Soon

# Getting Started

The AirRobe SDK contains UI components for Opt-In, Multi-Opt-In Views as well as Confirmation View.


## Integration

You are going to need `AppId` from the Provider which will be used to get the Category Mapping Infos and initialize the sub-widgets.

### Initialization

```swift
AirRobeWidget.initialize(
    config: AirRobeWidgetConfig(
        appId: "APP_ID",           // required
        privacyPolicyURL: String,  // required - privacy policy url of The Iconic
        color: String,             // optional - color HexCode without "#", default value is "42abc8"
        mode: enum                 // optional - (.production or .sandbox), default value is .production
    )
)
```


## Widget

### Opt-In View Initialization

```swift
var airRobeOptIn = AirRobeOptIn()
...
airRobeOptIn.initialize(
    brand: String?,                  // optional - e.g. "Chanel", can be nil
    material: String?,               // optional - e.g. "Leather", can be nil
    category: String,                // required - e.g. "Hats/fancy-hats"
    priceCents: Double,              // required - e.g. 100.95
    originalFullPriceCents: Double?, // optional - e.g. 62.00, can be nil
    rrpCents: Double?,               // optional - e.g. 62.00, can be nil
    currency: String,                // optional - default is "AUD"
    locale: String                   // optional - default is "en-AU"
)
```


### Multi-Opt-In View Initialization

```swift
var airRobeMultiOptIn = AirRobeMultiOptIn()
...
airRobeMultiOptIn.initialize(
    items: [String], // required - e.g. ["Accessories", "Accessories/Beauty", "Accessories/Bags/Leather bags/Weekender/Handbags", "Accessories/Bags/Clutches/Bum Bags"]
)
```


### Confirmation View Initialization

```swift
var airRobeConfirmation = AirRobeConfirmation()
...
airRobeConfirmation.initialize(
    orderId: String, // required - e.g. "123456" - the order id you got from the checkout.
    email: String,   // required
    fraudRisk: Bool  // optional - fraud status for the confirmation widget, default value is false.
)
```


### Clear Cache (Opt value reset)

```swift
AirRobeWidget.resetOptedIn()
```


### Get Order-Opt-In value

```swift
AirRobeWidget.orderOptedIn()
```


# Examples

The [example project][example] demonstrates how to include AirRobeWidget UI components.

# Building

## Running

Building and running the project is as simple as cloning the repository, opening [`AirRobeDemo.xcodeproj`][airrobedemo-workspace] and building the `AirRobeDemo` target.

[latest-release]: https://github.com/airrobe/widget-sdk-ios/releases/latest
[git-submodule]: https://git-scm.com/docs/git-submodule
[example]: https://github.com/airrobe/widget-sdk-ios/tree/master/AirRobeDemo
[airrobedemo-workspace]: AirRobeDemo/AirRobeDemo.xcodeproj
