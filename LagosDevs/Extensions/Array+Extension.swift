//
//  Array+Extension.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/11/22.
//

import Foundation

extension Array {
    mutating func appendDistinct<S>(contentsOf newElements: S, where condition:@escaping (Element, Element) -> Bool) where S : Sequence, Element == S.Element {
      newElements.forEach { (item) in
        if !(self.contains(where: { (selfItem) -> Bool in
            return !condition(selfItem, item)
        })) {
            self.append(item)
        }
    }
  }
}
