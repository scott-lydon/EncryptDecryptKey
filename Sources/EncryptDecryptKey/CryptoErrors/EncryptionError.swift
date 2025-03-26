//
//  File.swift
//  EncryptDecryptKey
//
//  Created by Scott Lydon on 3/25/25.
//

import Foundation

public extension String {

    static var combinedDataUnavailableMessage: String {
        """
        Failed to extract the combined encrypted data from AES.GCM.SealedBox.

        Possible Causes:
        - The AES.GCM.SealedBox creation failed or returned nil.
        - There may be platform incompatibility or version mismatch (Linux/macOS Crypto).
        - Memory issues or corrupted input data.
        - Missing or incorrect nonce/IV during encryption.

        Best Practices to Prevent:
        - Ensure the encryption input is valid and non-empty.
        - Provide a valid AES.GCM.Nonce when needed.
        - Confirm that the swift-crypto library version is compatible with the target platform.
        - Always handle the AES.GCM.SealedBox creation error and avoid forced unwrapping.
        """
    }
}

public enum EncryptionError: Error, LocalizedError {
    case combinedDataUnavailable

    public var errorDescription: String? {
        switch self {
        case .combinedDataUnavailable:
            return .combinedDataUnavailableMessage
        }
    }
}
