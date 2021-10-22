//
//  AppDelegate.swift
//  Madagascar
//
//  Created by Thisisme Hi on 2021/10/23.
//

import UIKit
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // 여기서 current는 현재 앱의 UNUserNotificationCenter에 대한 위임처리를 말하는 것임.
            UNUserNotificationCenter.current().delegate = self
            
            // 앱에서 요청할 푸시 알림 권한의 종류와 관련된 옵션을 만든다. 이 경우 경고, 배지 및 소리를 요구.
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications() // -> 원격 알림을 위해 앱을 등록 == 서버로부터 push를 앱에 띄우는 것
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    // 앱이 시작되거나 파이어베이스가 토큰을 업데이트할 때마다 파이어베이스는 앱과 동기화를 유지하기 위해 방금 추가한 메소드를 호출
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // 현재 등록 토큰 접근하기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // willPresent : 앱이 포그라운드에 있는 동안 알림을 받을 때마다 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        
        // 포그라운드에 있을 때 어떤 거 받고 싶은데?? - 소리, 뱃지, 배너 등..
        completionHandler([[.sound, .badge, .banner]])
    }
    
    // didReceive : 푸쉬 알림 클릭하면 실행되는 메소드
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // 여기 userinfo는 서버에서 보내주는 것...
        let userInfo = response.notification.request.content.userInfo["hi"] as? String
        if userInfo != nil {
            print("앱델레케이트 푸시타고 들어옴, userinfo 있음")
            if UIApplication.shared.applicationState == .active {
                print("포그라운드에서 클릭")
                let vc = ViewController()
                window?.rootViewController?.present(vc, animated: true, completion: nil)
                
            } else {
                print("백그라운드에서 클릭")
            }
        } else {
            print("앱델레케이트 푸시타고 들어옴, userinfo 없음")
        }
        completionHandler()
    }
    
    // APN은 사용자가 푸시 알림 권한을 부여하면 토큰을 생성하고 등록합니다.
    // 이 토큰은 개별 장치를 식별하므로 알림을 보낼 수 있습니다.
    // 파이어베이스를 사용하여 알림을 배포하면 이 코드가 해당 토큰을 파이어베이스에서 사용할 수 있게 됩니다.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
    }
}
