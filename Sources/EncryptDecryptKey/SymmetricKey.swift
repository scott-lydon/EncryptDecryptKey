//
//  SymmetricKey.swift
//  akin
//
//  Created by Scott Lydon on 3/30/24.
//  Copyright © 2024 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import CryptoKit

@available(iOS 13.0, macOS 10.15, *)
public extension SymmetricKey {
    /// Returns a SymmetricKey or throws a specific error if the nonce is invalid
    static public func theKey(nonce: [UInt8] = theNonce) throws -> SymmetricKey {
        let minLength = 16   // Recommended minimum for AES-GCM (128 bits)
        let maxLength = 64   // Arbitrary upper bound for sanity check

        guard !nonce.isEmpty else {
            throw SymmetricKeyError.emptyNonce
        }

        guard nonce.count >= minLength else {
            throw SymmetricKeyError.insufficientEntropy(minBytes: minLength, actual: nonce.count)
        }

        guard nonce.count <= maxLength else {
            throw SymmetricKeyError.tooLarge(maxBytes: maxLength, actual: nonce.count)
        }

        return SymmetricKey(data: Data(nonce))
    }
}
