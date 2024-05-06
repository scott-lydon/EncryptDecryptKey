//
//  DataCrypto.swift
//  akin
//
//  Created by Scott Lydon on 4/1/24.
//  Copyright © 2024 ElevatedUnderdogs. All rights reserved.
//

import Foundation
#if canImport(CryptoKit)
import CryptoKit
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension Data {
    /// Using the shared key defined earlier
    func encrypt<D: ContiguousBytes>(with key: D = []) throws -> Data {
        try AES.GCM.seal(self, using: SymmetricKey(data: key)).combined!
    }

    func decrypt<D: ContiguousBytes>(with key: D = []) throws -> Data {
        try AES.GCM.open(AES.GCM.SealedBox(combined: self), using: SymmetricKey(data: key))
    }

    func decrypted<T: Codable>() throws -> T {
        try JSONDecoder().decode(T.self, from: decrypt())
    }
}
#elseif canImport(Vapor)
import Vapor

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension Data {
    /// Using the shared key defined earlier
    func encrypt(with key: [UInt8] = []) throws -> Data {
        try AES.GCM.seal(self, using: SymmetricKey(data: key)).combined!
    }

    func decrypt(with key: [UInt8] = []) throws -> Data {
        try AES.GCM.open(AES.GCM.SealedBox(combined: self), using: SymmetricKey(data: key))
    }

    func decrypted<T: Codable>() throws -> T {
        try JSONDecoder().decode(T.self, from: decrypt())
    }
}

#endif


