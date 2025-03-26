//
//  File.swift
//  EncryptDecryptKey
//
//  Created by Scott Lydon on 3/25/25.
//

import Foundation
import Crypto

// MARK: - DataProtocol Hash Extensions (swift-crypto)
public extension DataProtocol {
    var sha256digest: SHA256Digest { SHA256.hash(data: self) }
    var sha384digest: SHA384Digest { SHA384.hash(data: self) }
    var sha512digest: SHA512Digest { SHA512.hash(data: self) }

    func sealedBox() throws -> AES.GCM.SealedBox {
        try AES.GCM.SealedBox(combined: Data(self))
    }

    func decrypt(using key: SymmetricKey? = nil) throws -> Data {
        var buffer: SymmetricKey
        if let key {
            buffer = key
        } else {
            buffer = try .theKey()
        }
        return try AES.GCM.open(try sealedBox(), using: buffer)
    }
}
