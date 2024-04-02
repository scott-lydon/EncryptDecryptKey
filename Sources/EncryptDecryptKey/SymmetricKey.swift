//
//  SymmetricKey.swift
//  akin
//
//  Created by Scott Lydon on 3/30/24.
//  Copyright © 2024 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import CryptoKit

var theNonce: [UInt8] = [
    73, 231, 96, 51, 140, 91, 104, 168, 0, 114, 107, 8, 210, 143, 179, 115,
    252, 177, 250, 213, 33, 115, 0, 223, 30, 7, 80, 157, 17, 120, 36, 175
]

@available(iOS 13.0, *)
extension SymmetricKey {
    /// This should match the server's key for encryption/decryption to work
    static func theKey(nonce: [UInt8] = theNonce) -> SymmetricKey {
        SymmetricKey(data: Data(nonce))
    }
}
