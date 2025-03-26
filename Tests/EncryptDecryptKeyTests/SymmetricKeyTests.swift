//
//  File.swift
//  EncryptDecryptKey
//
//  Created by Scott Lydon on 3/25/25.
//
import XCTest
@testable import EncryptDecryptKey
import Crypto

final class SymmetricKeyTests: XCTestCase {

    public func testEmptyNonceThrows() {
        let emptyNonce: [UInt8] = []
        XCTAssertThrowsError(try SymmetricKey.theKey(nonce: emptyNonce)) { error in
            XCTAssertEqual(error as? SymmetricKeyError, .emptyNonce)
        }
    }

    public func testInsufficientEntropyThrows() {
        let shortNonce: [UInt8] = [0x01, 0x02, 0x03] // Less than 16 bytes
        XCTAssertThrowsError(try SymmetricKey.theKey(nonce: shortNonce)) { error in
            if case let .insufficientEntropy(minBytes, actual) = error as? SymmetricKeyError {
                XCTAssertEqual(minBytes, 16)
                XCTAssertEqual(actual, 3)
            } else {
                XCTFail("Expected insufficientEntropy error")
            }
        }
    }

    public func testTooLargeNonceThrows() {
        let largeNonce: [UInt8] = Array(repeating: 0x00, count: 65) // More than 64 bytes
        XCTAssertThrowsError(try SymmetricKey.theKey(nonce: largeNonce)) { error in
            if case let .tooLarge(maxBytes, actual) = error as? SymmetricKeyError {
                XCTAssertEqual(maxBytes, 64)
                XCTAssertEqual(actual, 65)
            } else {
                XCTFail("Expected tooLarge error")
            }
        }
    }

    public func testValidNonceCreatesKey() throws {
        let validNonce: [UInt8] = Array(repeating: 0xAB, count: 32) // Between 16 and 64 bytes
        let key = try SymmetricKey.theKey(nonce: validNonce)
        let keyData = key.withUnsafeBytes { Data($0) }
        XCTAssertEqual(keyData, Data(validNonce))
    }

    public func testErrorDescriptions() {
        let emptyError = SymmetricKeyError.emptyNonce
        XCTAssertTrue(emptyError.localizedDescription.contains("Nonce array is empty"))

        let insufficientError = SymmetricKeyError.insufficientEntropy(minBytes: 16, actual: 3)
        XCTAssertTrue(insufficientError.localizedDescription.contains("Minimum required: 16 bytes, but got: 3"))

        let tooLargeError = SymmetricKeyError.tooLarge(maxBytes: 64, actual: 70)
        XCTAssertTrue(tooLargeError.localizedDescription.contains("Max allowed: 64 bytes, but got: 70"))
    }

    public func testCombinedDataUnavailable() {
        XCTAssertEqual(String.combinedDataUnavailableMessage, EncryptionError.combinedDataUnavailable.errorDescription)
    }

    public func testNSErrorThrownWhenCombinedIsNil() {
        let data = Data("test".utf8)
        do {
            theNonce = [0, 1, 2]
            _ = try data.encrypt()
            XCTFail("Expected NSError to be thrown")
        } catch let error as NSError {
            XCTAssertTrue(error.domain.contains("EncryptDecryptKey"))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
        theNonce = []
    }

    public func testDecryptUsesProvidedKey() throws {
        let key = SymmetricKey(size: .bits256)
        let data = Data("Secret".utf8)
        let encrypted = try data.encrypt(using: key)
        let decrypted = try encrypted.decrypt(using: key)
        XCTAssertEqual(decrypted, data)
    }

    public func testDecryptedUsesTheKey() throws {
        // Mock .theKey() to be deterministic (your .theKey() must support test override)
        theNonce = Array(repeating: 1, count: 32)
        let original = TestStruct(name: "John", age: 30)
        let encoded = try JSONEncoder().encode(original)
        let encrypted = try encoded.encrypt()  // uses .theKey()

        let decoded: TestStruct = try encrypted.decrypted()
        XCTAssertEqual(decoded, original)
    }

    public func failEncrypted() {
        do {
            let _ = try "TestThis".encrypted(using: .theKey(nonce: [1, 2, 3]))
            XCTFail()
        } catch {
            XCTAssertEqual(error as? EncryptionError, EncryptionError.combinedDataUnavailable)
        }
    }
}
