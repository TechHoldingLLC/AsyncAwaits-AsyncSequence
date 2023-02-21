//
//  NSObject.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 16/02/23.
//

import Foundation

extension NSObject {

    static var reusableIdentifier: String {
        get {
            return "\(self)"
        }
    }
}
