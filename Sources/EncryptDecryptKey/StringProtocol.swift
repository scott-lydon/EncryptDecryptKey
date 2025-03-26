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

    func sealed(using key: SymmetricKey, nonce: AES.GCM.Nonce? = nil) throws -> AES.GCM.SealedBox {
        try AES.GCM.seal(data, using: key, nonce: nonce)
    }

    func encrypted(using key: SymmetricKey) throws -> Data {
        guard let combined = try sealed(using: key).combined else {
            // near impossible case to reach, the nonce is validated by the sealed box
            throw EncryptionError.combinedDataUnavailable
        }
        return combined
    }
}
