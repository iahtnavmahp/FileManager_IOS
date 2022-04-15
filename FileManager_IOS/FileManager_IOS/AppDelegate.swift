//
//  AppDelegate.swift
//  FileManager_IOS
//
//  Created by Pham Van Thai on 13/04/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var delegate: CheckReferenceDocumentDelegate?
    var vc = HomeViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
                window?.backgroundColor = .white
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
        self.delegate = vc
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let fileIO = DocumentManager()
        let count = fileIO.getAttributesOfItemDocuments(fileName: "Images")
        delegate?.pushCountReference(idx: count)
        
    }

}

