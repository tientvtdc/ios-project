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
        configureApplicationScreen()
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      // Pass device token to auth
      Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
    func configureApplicationScreen() {

            guard let rootNav = window?.rootViewController as? UINavigationController else {
                return
            }

             // Might need to change the code inside if let depending your requirement
        if let currentUser = Auth.auth().currentUser  {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sideMenuVC = storyboard.instantiateViewController(withIdentifier: "goToHomeFromLoginScreen")
                rootNav.navigationBar.isHidden = true
                rootNav.addChild(sideMenuVC)
            }
        }
}
