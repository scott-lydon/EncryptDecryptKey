//
//  File.swift
//  EncryptDecryptKey
//
//  Created by Scott Lydon on 3/25/25.
//

import Foundation

/// Error types specific to SymmetricKey creation
public enum SymmetricKeyError: Error, LocalizedError, Equatable {
    case emptyNonce
    case insufficientEntropy(minBytes: Int, actual: Int)
    case tooLarge(maxBytes: Int, actual: Int)

    public var errorDescription: String? {
        switch self {
        case .emptyNonce:
            return "Nonce array is empty. Provide a valid nonce with entropy."
        case .insufficientEntropy(let min, let actual):
            return "Nonce has insufficient entropy. Minimum required: \(min) bytes, but got: \(actual) bytes."
        case .tooLarge(let max, let actual):
            return "Nonce exceeds maximum allowed size. Max allowed: \(max) bytes, but got: \(actual) bytes."
        }
    }
}
