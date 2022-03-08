//
//  AppDelegate.swift
//  AirRobeDemo
//
//  Created by King on 11/22/21.
//

import UIKit
import AirRobeWidget

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Initialize AirRobeWidget with appId and privacy policy link for The Iconic
        AirRobeWidget.initialize(
            config: AirRobeWidgetConfig(
                appId: "c43f2be28f1f",
                privacyPolicyURL: "https://www.theiconic.com.au/privacy-policy",
                mode: .production
            )
        )

        // This part is how you can configure the colors of the Widgets globally
//        AirRobeWidget.AirRobeTextColor = .systemBlue
//        AirRobeWidget.AirRobeBorderColor = .blue
//        AirRobeWidget.AirRobeLinkTextColor = .brown
//        AirRobeWidget.AirRobeArrowColor = .yellow
//        AirRobeWidget.AirRobeSeparatorColor = .yellow
//        AirRobeWidget.AirRobeSwitchColor = .yellow
//        AirRobeWidget.AirRobeButtonTextColor = .yellow
//        AirRobeWidget.AirRobeButtonBorderColor = .yellow
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

