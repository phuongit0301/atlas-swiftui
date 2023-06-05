//
//  AppDelegate.swift
//  ATLAS
//
//  Created by phuong phan on 04/06/2023.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
      
      if let userActivity = options.userActivities.first {
          switch userActivity.activityType {
          case "atlas.SceneTwo":
              let sceneTwoConfiguration = UISceneConfiguration(
                name: "SceneTwo",
                sessionRole: connectingSceneSession.role
              )
              sceneTwoConfiguration.delegateClass = SceneTwoDelegate.self
              return sceneTwoConfiguration
              
          default:
              break
          }
      }
    
      return UISceneConfiguration(
        name: "MainScene",
        sessionRole: connectingSceneSession.role
      )
  }
}
