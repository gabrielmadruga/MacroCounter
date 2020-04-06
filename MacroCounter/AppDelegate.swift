//
//  AppDelegate.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/7/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreData = CoreDataStack(modelName: "Model")	

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()
        self.window = window
        
//        let onboardingViewController = OnboardingViewController.instantiate(fromStoryboard: .onboarding)
        window.rootViewController = UIStoryboard(.main).instantiateInitialViewController()
        window.makeKeyAndVisible()
        
        let managedContext = coreData.managedContext
        if (try! managedContext.fetch(Profile.fetchRequest() as NSFetchRequest<Profile>)).first == nil {
            let profile = Profile.init(context: managedContext)
            let dailyTarget = DailyTarget.init(context: managedContext)
            dailyTarget.calories = 2000
            dailyTarget.fats = 40
            dailyTarget.carbs = 100
            dailyTarget.proteins = 100
            dailyTarget.profile = profile
            try! managedContext.save()
        }
        UserDefaults.standard.userInterfaceStyle = .unspecified
        if let userInterfaceStyle = UserDefaults.standard.userInterfaceStyle {
            window.overrideUserInterfaceStyle = userInterfaceStyle
        }
        
        #warning("This is just for debugging")
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(url!.absoluteString)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreData.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreData.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

