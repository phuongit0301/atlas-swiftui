//
//  SceneSessionKey.swift
//  ATLAS
//
//  Created by phuong phan on 04/06/2023.
//

import SwiftUI
import UIKit

struct SceneSessionKey: EnvironmentKey {
  static var defaultValue: UISceneSession?
}

extension EnvironmentValues {
  var sceneSession: UISceneSession? {
    get {
      return self[SceneSessionKey.self]
    }
    set {
      self[SceneSessionKey.self] = newValue
    }
  }
}
