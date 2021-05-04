//
//  Player+KVO.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 04.05.2021.
//

import Foundation

extension Player {
  @objc var sectionIdentifier: String {
      get {
        return self.position ?? ""
      }
  }
}
