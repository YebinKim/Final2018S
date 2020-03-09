//
//  AppDelegate.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 14..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var ID: String?
    var userName: String? = "Guest"
    var userProfilePic: String?
    var userMaxScore: String? = "0"
    var userPlayCounts: String?
    
    var userScoreNo: String?
    var userScore: String?
    var scoreDate: String?
    var scoreMemo: String?
    
    var flagLogin:Bool? = false
    
    var bakgroundAudioPlayer: AVAudioPlayer?
    
    var clickEffectAudioPlayer: AVAudioPlayer?
    var alignedEffectAudioPlayer: AVAudioPlayer?
    var selectedEffectAudioPlayer: AVAudioPlayer?
    var moveFailEffectAudioPlayer: AVAudioPlayer?
    var moveSuccessEffectAudioPlayer: AVAudioPlayer?
    
    var effectArray:Array<AVAudioPlayer?> = []
    
    var userInfoFetchedArray: [UserData] = Array()
    
    func userInfoDownloadDataFromServer() -> Void {
        let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_UserTable.php"
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userID = appDelegate.ID else { return }
        
        let restString: String = "id=" + userID
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else { print("Error: not receiving Data"); return; }
            let response = response as! HTTPURLResponse
            
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: UserData = UserData()
                        var jsonElement = jsonData[i]
                        newData.id = jsonElement["ID"] as! String
                        newData.pw = jsonElement["PW"] as! String
                        newData.name = jsonElement["Name"] as! String
                        newData.profilePic = jsonElement["ProfilePic"] as! String
                        newData.maxScore = jsonElement["MaxScore"]  as! String
                        newData.playCounts = jsonElement["PlayCounts"]  as! String
                        self.userInfoFetchedArray.append(newData)
                        
                        self.ID = newData.id
                        self.userName = newData.name
                        self.userProfilePic = newData.profilePic
                        self.userMaxScore = newData.maxScore
                        self.userPlayCounts = newData.playCounts
                    }
                }
            } catch {
                print("Error:")
            }
        }
        task.resume()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
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
        
        bakgroundAudioPlayer = nil
        
        // import시킨 음원에 대한 리소스를 받아옴
        let backgroundUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "BayBreeze", ofType:"wav")!)
        
        let clickUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "SoundClick", ofType:"wav")!)
        let selectedUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "SoundSelected", ofType:"WAV")!)
        let moveFailUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "SoundMoveFail", ofType:"wav")!)
        let moveSuccessUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "SoundMoveSuccess", ofType:"wav")!)
        
        // AVAudioPlayer 인스턴스 생성
        do{
            try bakgroundAudioPlayer = AVAudioPlayer(contentsOf: backgroundUrl)
            
            try clickEffectAudioPlayer  = AVAudioPlayer(contentsOf: clickUrl)
            try selectedEffectAudioPlayer  = AVAudioPlayer(contentsOf: selectedUrl)
            try moveFailEffectAudioPlayer  = AVAudioPlayer(contentsOf: moveFailUrl)
            try moveSuccessEffectAudioPlayer  = AVAudioPlayer(contentsOf: moveSuccessUrl)
            
            effectArray.append(clickEffectAudioPlayer)
            effectArray.append(selectedEffectAudioPlayer)
            effectArray.append(moveFailEffectAudioPlayer)
            effectArray.append(moveSuccessEffectAudioPlayer)
            
            if bakgroundAudioPlayer == nil {
                print("audioPlayer error")
            }else{
                bakgroundAudioPlayer?.delegate = self as? AVAudioPlayerDelegate
                bakgroundAudioPlayer?.prepareToPlay()
                
                for i in 0 ... 3 {
                    effectArray[i]?.delegate = self as? AVAudioPlayerDelegate
                    effectArray[i]?.prepareToPlay()
                }
            }
        }catch{
            print("Error ==> \(error)")
        }
        
        // 반복재생
        bakgroundAudioPlayer?.numberOfLoops = -1
        
        bakgroundAudioPlayer?.volume = 0.7
        
        for i in 0 ... 3 {
            effectArray[i]?.volume = 0.7
        }
        
        if let player = bakgroundAudioPlayer {
            player.play()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "univerSwuSaga")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

