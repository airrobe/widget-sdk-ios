# AirRobeWidget

The AirRobeWidget iOS SDK provides conveniences to make your AirRobeWidget integration experience as smooth and straightforward as possible. We're working on crafting a great framework for developers with easy drop in components to integrate our widgets easy for your customers.

# Integration

## Requirements

- iOS 13.0+
- Swift 5.3+
- Xcode 12.0+


## Swift Package Manager (recommended)

This is the recommended integration method.

```
dependencies: [
    .package(url: "https://github.com/airrobe/widget-sdk-ios.git", .upToNextMajor(from: "x.x.x"))
]
```

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
        mode: enum                 // optional - (.production or .sandbox), default value is .production
    )
)
```

### Color configuration
```swift
AirRobeWidget.AirRobeTextColor = .systemBlue       // the color of the widget text. default value is "#232323"
AirRobeWidget.AirRobeBorderColor = .blue           // the color of the widget border. default value is "#DFDFDF"
AirRobeWidget.AirRobeLinkTextColor = .brown        // the color of the widget legal copy text. default value is "#696969"
AirRobeWidget.AirRobeArrowColor = .yellow          // the color of the widget drop down arrow icon. default value is "#42ABC8"
AirRobeWidget.AirRobeSeparatorColor = .yellow      // the color of the learn more popup view separators. default value is "#DFDFDF"
AirRobeWidget.AirRobeSwitchColor = .yellow         // the color of the widget switch ON color. default value is "#42ABC8"
AirRobeWidget.AirRobeButtonTextColor = .yellow     // the color of the widget activate button text. default value is "#232323"
AirRobeWidget.AirRobeButtonBorderColor = .yellow   // the color of the widget activate button border. default value is "#232323"
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
    department: String?,             // optional - e.g. "Kidswear"
    priceCents: Double,              // required - e.g. 100.95
    originalFullPriceCents: Double?, // optional - e.g. 62.00, can be nil
    rrpCents: Double?,               // optional - e.g. 62.00, can be nil
    currency: String,                // optional - default is "AUD"
    locale: String                   // optional - default is "en-AU"
)

// Color configuration
airRobeOptIn.borderColor = .red         // the color of the widget border. default value is "#DFDFDF"
airRobeOptIn.linkTextColor = .yellow    // the color of the widget legal copy text. default value is "#696969"
airRobeOptIn.textColor = .blue          // the color of the widget text. default value is "#232323"
airRobeOptIn.arrowColor = .black        // the color of the widget drop down arrow icon. default value is "#42ABC8"
airRobeOptIn.switchColor = .black       // the color of the widget switch ON color. default value is "#42ABC8"
```


### Multi-Opt-In View Initialization

```swift
var airRobeMultiOptIn = AirRobeMultiOptIn()
...
airRobeMultiOptIn.initialize(
    items: [String], // required - e.g. ["Accessories", "Accessories/Beauty", "Accessories/Bags/Leather bags/Weekender/Handbags", "Accessories/Bags/Clutches/Bum Bags"]
)

// Color configuration
airRobeMultiOptIn.borderColor = .red         // the color of the widget border. default value is "#DFDFDF"
airRobeMultiOptIn.linkTextColor = .yellow    // the color of the widget legal copy text. default value is "#696969"
airRobeMultiOptIn.textColor = .blue          // the color of the widget text. default value is "#232323"
airRobeMultiOptIn.arrowColor = .black        // the color of the widget drop down arrow icon. default value is "#42ABC8"
airRobeMultiOptIn.switchColor = .black       // the color of the widget switch ON color. default value is "#42ABC8"
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

// Color configuration
airRobeConfirmation.borderColor = .red           // the color of the widget border. default value is "#DFDFDF"
airRobeConfirmation.textColor = .blue            // the color of the widget text. default value is "#232323"
airRobeConfirmation.buttonBorderColor = .black   // the color of the widget activate button border. default value is "#232323"
airRobeConfirmation.buttonTextColor = .black     // the color of the widget activate button text. default value is "#232323"
```


### Clear Cache (Opt value reset)

```swift
AirRobeWidget.resetOptedIn()
```


### Get Order-Opted-In value

```swift
AirRobeWidget.orderOptedIn()
```

### Check Multi-Opt-In Eligibility

```swift
AirRobeWidget.checkMultiOptInEligibility(items: [String]) -> Bool
```

### Check Confirmation Widget Eligibility

```swift
AirRobeWidget.checkConfirmationEligibility(orderId: String, email: String, fraudRisk: Bool) -> Bool
```

### Track Page View

```swift
AirRobeWidget.trackPageView(pageName: String)
```

# Examples

The [example project][example] demonstrates how to include AirRobeWidget UI components.

# Building

## Running

Building and running the project is as simple as cloning the repository, opening [`AirRobeDemo.xcodeproj`][airrobedemo-workspace] and building the `AirRobeDemo` target.

[example]: https://github.com/airrobe/widget-sdk-ios/tree/master/AirRobeDemo
[airrobedemo-workspace]: AirRobeDemo/AirRobeDemo.xcodeproj
