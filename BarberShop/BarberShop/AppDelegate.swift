//
//  AppDelegate.swift
//  HamburgerMenu
//
//  Created by Kashyap on 13/11/20.
//

import UIKit
import FirebaseAuth
import  Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    FirebaseApp.configure();
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      // Pass device token to auth
      Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
}
