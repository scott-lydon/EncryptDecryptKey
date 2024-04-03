//
//  SymmetricKey.swift
//  akin
//
//  Created by Scott Lydon on 3/30/24.
//  Copyright © 2024 ElevatedUnderdogs. All rights reserved.
//

#if canImport(CryptoKit)
// Your CryptoKit code here
import Foundation
import CryptoKit

public var theNonce: [UInt8] = []


@available(iOS 13.0, macOS 10.15, *)
public extension SymmetricKey {
    /// This should match the server's key for encryption/decryption to work
    static func theKey(nonce: [UInt8] = theNonce) -> SymmetricKey {
        SymmetricKey(data: Data(nonce))
    }
}

#endif
