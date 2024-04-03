//
//  DataCrypto.swift
//  akin
//
//  Created by Scott Lydon on 4/1/24.
//  Copyright © 2024 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import CryptoKit

@available(iOS 13.0, macOS 10.15, *)
public extension Data {
    /// Using the shared key defined earlier
    func encrypt() throws -> Data {
        try AES.GCM.seal(self, using: .theKey()).combined!
    }

    func decrypt() throws -> Data {
        try AES.GCM.open(AES.GCM.SealedBox(combined: self), using: .theKey())
    }

    func decrypted<T: Codable>() throws -> T {
        try JSONDecoder().decode(T.self, from: decrypt())
    }
}
