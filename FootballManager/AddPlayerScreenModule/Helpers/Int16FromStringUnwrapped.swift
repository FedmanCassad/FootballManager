//
//  Int16FromStringUnwrapped.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 01.04.2021.
//

import Foundation


extension Optional where Wrapped == String {
  func safeInt16() -> Int16  {
    guard let self = self,
          let int16 = Int16(self) else {
      return 0
    }
    return int16
  }
}

extension String {
  func safeInt16() -> Int16  {
    guard let int16 = Int16(self) else {
      return 0
    }
    return int16
  }
}
