//
//  AppDelegate.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FlickrAPI.configWith(apikey: AppConstants.flickrAPIKey,
                             secret: AppConstants.flickrAPISecret,
                            baseURL: AppConstants.baseURL)
        
        
        window?.rootViewController = rootViewController(launchOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func rootViewController(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> UIViewController {
        
        
        if CommandLine.arguments.isEmpty {
            // Application Business Logic to decide the first view controller
            return UIStoryboard(name: "SearchImage", bundle: nil).instantiateViewController(withIdentifier: "SearchImageNavigationVC") as! UINavigationController
        } else {
            // Is under testing
            // Extraction of UI testing commandline argumanets
            if CommandLine.arguments.contains(UITestCommandLineArgument.search.rawValue) {
                // Prepare Test Env for Login flow testing
                return UIStoryboard(name: "SearchImage", bundle: nil).instantiateViewController(withIdentifier: "SearchImageNavigationVC") as! UINavigationController
            } else if CommandLine.arguments.contains(UITestCommandLineArgument.details.rawValue) {
                // Present Sign up Screen
                
                // TODO: Create a separete Builder for Each Module
                let view = UIStoryboard(name: "SearchDetails", bundle: nil).instantiateViewController(withIdentifier: "SearchDetailsVC") as! SearchDetailsVC
                let testphoto = Photo(id: "48256336996",
                                      owner: "33264540@N05",
                                      secret: "5a53a81b31",
                                      server: "65535",
                                      farm: 66,
                                      title: "fish kebab seller at Zakaria street, Kolkata",
                                      ispublic: 1,
                                      isfriend: 0,
                                      isfamily: 0,
                                      urlT: "https://live.staticflickr.com/65535/48256336996_5a53a81b31_t.jpg",
                                      heightT: "68",
                                      widthT: "100",
                                      photoLoadStatus: .unknown)
                let vm = SearchDetailsViewModel(view: view, title: "Image Details", photo: testphoto, api: FlickrAPI.store)
                ImageStore.shared.purge()
                view.viewModel = vm
                return view
            }
        }
        
        // Default First Screen
        return UIStoryboard(name: "SearchImage", bundle: nil).instantiateViewController(withIdentifier: "SearchImageNavigationVC") as! UINavigationController
    }


}





