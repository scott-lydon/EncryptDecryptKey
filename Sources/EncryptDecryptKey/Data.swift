//
//  DataCrypto.swift
//  akin
//
//  Created by Scott Lydon on 4/1/24.
//  Copyright © 2024 ElevatedUnderdogs. All rights reserved.
//

import Crypto
import Foundation

public extension Data {

    func encrypt(using key: SymmetricKey? = nil) throws -> Data {
        var buffer: SymmetricKey
        if let key {
            buffer = key
        } else {
            buffer = try .theKey()
        }
        let sealedBox = try AES.GCM.seal(self, using: buffer)
        guard let combined = sealedBox.combined else {
            // near impossible case to reach, the nonce is validated by the sealed box
            throw NSError(
                domain: "EncryptDecryptKey",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to get combined data"]
            )
        }
        return combined
    }

    func decrypted<T: Decodable>(using key: SymmetricKey? = nil) throws -> T {
        var buffer: SymmetricKey
        if let key {
            buffer = key
        } else {
            buffer = try .theKey()
        }
        let decryptedData = try decrypt(using: buffer)
        return try JSONDecoder().decode(T.self, from: decryptedData)
    }

    static func randomBytes(count: Int) -> Data {
        // Ensure count is positive
        guard count > 0 else { return Data() }

        // Create a buffer to hold the random bytes
        var bytes = [UInt8](repeating: 0, count: count)

        // Use SystemRandomNumberGenerator for cryptographically secure random numbers
        var rng = SystemRandomNumberGenerator()

        // Fill the buffer with random bytes
        for i in 0..<count {
            bytes[i] = UInt8.random(in: 0...255, using: &rng)
        }

        // Convert bytes to Data and return
        return Data(bytes)
    }
}
