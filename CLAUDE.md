# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Native iOS SDK providing AirRobe widgets (OptIn, MultiOptIn, Confirmation) for integration into iOS apps. Distributed via Swift Package Manager.

## Tech Stack

- Swift 5.5+, iOS 13.0+
- Swift Package Manager (no external dependencies)
- XCTest, Combine framework

## Commands

- **Build:** `swift build`
- **Test:** `swift test`
- **Open demo:** `open AirRobeDemo/AirRobeDemo.xcodeproj`

## Architecture

- `Sources/AirRobeWidget/AirRobeWidget.swift` — Main entry point (module-level functions, not a class)
- `Sources/AirRobeWidget/Widgets/` — Public widget views: AirRobeOptIn, AirRobeMultiOptIn, AirRobeConfirmation
- `Sources/AirRobeWidget/Views/` — View implementations with Default and Enhanced variants (XIB-based)
- `Sources/AirRobeWidget/Service/` — Networking (GraphQL API), response models
- `Sources/AirRobeWidget/Config/` — Configuration, event delegate, shopping data singleton
- `Sources/AirRobeWidget/Utils/` — UIKit extensions
- `Sources/AirRobeWidget/Resources/` — Strings (Default/Enhanced variants), assets
- `Tests/AirRobeWidgetTests/` — XCTest unit tests (eligibility logic, JSON mapping)
- `AirRobeDemo/` — Demo app (Xcode project, iOS 15.0+)

## Public API

```swift
AirRobeWidget.initialize(config: AirRobeWidgetConfig)  // Must call first
AirRobeWidget.trackPageView(pageName:)
AirRobeWidget.checkMultiOptInEligibility(items:) -> Bool
AirRobeWidget.checkConfirmationEligibility(orderId:email:fraudRisk:) -> Bool
AirRobeWidget.resetOrder() / resetOptedIn() / orderOptedIn() -> Bool
```

13 color properties (e.g. `AirRobeBorderColor`, `AirRobeTextColor`, `AirRobeSwitchOnTintColor`) for theming.

## Conventions

- Variant pattern: Default and Enhanced UI loaded from separate XIB files (A/B testing)
- ViewModels use Combine `@Published` properties for async state
- `AirRobeShoppingDataModelInstance.shared` singleton for global state
- UserDefaults for caching opt-in flags
- Distribution: SPM only (CocoaPods/Carthage not yet implemented)
- No CI/CD configured

## Gotchas

- `initialize()` fetches category mappings asynchronously — widgets won't work until it completes
- Color properties must be set before widget initialization; won't affect already-rendered views
- Category mapping is a shared singleton across all widget instances
- `#if canImport(UIKit)` guards prevent compilation on non-UIKit platforms
