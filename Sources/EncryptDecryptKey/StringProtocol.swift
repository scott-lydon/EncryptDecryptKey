//
//  File.swift
//  EncryptDecryptKey
//
//  Created by Scott Lydon on 3/25/25.
//

import Foundation
import Crypto

public extension StringProtocol {

    // MARK: - StringProtocol Hexa and Digest

    var data: Data { Data(utf8) }
    var hexaData: Data { Data(hexa) }
    var hexaBytes: [UInt8] { Array(hexa) }

    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            let nextIndex = self.index(index, offsetBy: 2, limitedBy: endIndex) ?? endIndex
            defer { index = nextIndex }
            return UInt8(self[index..<nextIndex], radix: 16)
        }
    }

    var sha256hexa: String { data.sha256digest.map { String(format: "%02x", $0) }.joined() }
    var sha384hexa: String { data.sha384digest.map { String(format: "%02x", $0) }.joined() }
    var sha512hexa: String { data.sha512digest.map { String(format: "%02x", $0) }.joined() }

    // MARK: - StringProtocol Encryption Extensions

    /// Encrypts the data using AES-GCM with the provided symmetric key and an optional nonce.
    /// - Parameters:
    ///   - key: The symmetric key used for encryption and decryption. Must be a secure, random value (e.g., 128 or 256 bits).
    ///   - nonce: An optional nonce (number used once) for AES-GCM. If `nil` (default), a random nonce is generated
    ///   automatically, ensuring uniqueness per encryption. If provided, it must be unique for each encryption with the same key
    ///   to maintain security; nonce reuse compromises confidentiality and authenticity.
    /// - Returns: An `AES.GCM.SealedBox` containing the encrypted data, authentication tag, and nonce (combined format).
    /// - Throws: An error if encryption fails (e.g., invalid key or nonce).
    /// - Note: The key does not embed the nonce; they are independent inputs. Use `nil` for nonce in most cases unless
    /// explicit nonce control is required (e.g., deterministic encryption or protocol-specific nonce derivation).
    func sealed(using key: SymmetricKey? = nil, nonce: AES.GCM.Nonce? = nil) throws -> AES.GCM.SealedBox {
        var buffer: SymmetricKey
        if let key {
            buffer = key
        } else {
            buffer = try .theKey()
        }
        return try AES.GCM.seal(data, using: buffer, nonce: nonce)
    }

    func encrypted(using key: SymmetricKey? = nil) throws -> Data {
        var buffer: SymmetricKey
        if let key {
            buffer = key
        } else {
            buffer = try .theKey()
        }
        guard let combined = try sealed(using: buffer).combined else {
            // near impossible case to reach, the nonce is validated by the sealed box
            throw EncryptionError.combinedDataUnavailable
        }
        return combined
    }
}
