//
//  File.swift
//  EncryptDecryptKey
//
//  Created by Scott Lydon on 3/25/25.
//

import Foundation
import XCTest
import Crypto
@testable import EncryptDecryptKey

final class CryptoExtensionsTests: XCTestCase {

    let testString = "Hello, world!"
    lazy var testData = testString.data(using: .utf8)!
    let testKey = SymmetricKey(size: .bits256)

    // MARK: - Hash Tests
    public func testSHA256Digest() {
        let digest = testData.sha256digest
        XCTAssertEqual(Data(digest).count, 32)  // SHA256 output size is 32 bytes
    }

    public func testSHA384Digest() {
        let digest = testData.sha384digest
        XCTAssertEqual(Data(digest).count, 48)
    }

    public func testSHA512Digest() {
        let digest = testData.sha512digest
        XCTAssertEqual(Data(digest).count, 64)
    }

    // MARK: - Hex Tests
    public func testHexConversions() {
        let hex = testString.sha256hexa
        XCTAssertFalse(hex.isEmpty)
        XCTAssertEqual(hex.count, 64)  // SHA256 produces 32 bytes -> 64 hex characters
    }

    public func testHexaDataAndBytes() {
        let hexString = "48656c6c6f" // "Hello" in hex
        XCTAssertEqual(String(data: hexString.hexaData, encoding: .utf8), "Hello")
        XCTAssertEqual(hexString.hexaBytes, [72, 101, 108, 108, 111])
    }

    // MARK: - Sealing and Encryption Tests
    public func testSealedBoxAndDecrypt() throws {
        let sealed = try testString.sealed(using: testKey)
        XCTAssertNotNil(sealed.combined)

        // Test decrypting the sealed box
        let combinedData = try XCTUnwrap(sealed.combined)
        let decrypted = try combinedData.decrypt(using: testKey)
        XCTAssertEqual(decrypted, testData)
    }

    public func testEncryptedfunction() throws {
        let encrypted = try testString.encrypted(using: testKey)
        let decrypted = try encrypted.decrypt(using: testKey)
        XCTAssertEqual(decrypted, testData)
    }

    // MARK: - Edge Cases
    public func testDecryptWithWrongKeyFails() throws {
        let encrypted = try testString.encrypted(using: testKey)
        let wrongKey = SymmetricKey(size: .bits256)

        XCTAssertThrowsError(try encrypted.decrypt(using: wrongKey)) { error in
            print("Expected decryption failure with wrong key: \(error)")
        }
    }

    public func testSealedBoxThrowsOnInvalidData() {
        let invalidData = Data([0x00, 0x01, 0x02])  // Not a valid AES-GCM combined box

        XCTAssertThrowsError(try invalidData.sealedBox()) { error in
            print("Expected failure: \(error)")
        }
    }

    public func testEmptyStringHashing() {
        let empty = ""
        XCTAssertEqual(empty.sha256hexa.count, 64)
        XCTAssertEqual(empty.sha384hexa.count, 96)
        XCTAssertEqual(empty.sha512hexa.count, 128)
    }

    public func testHexInvalidCharacters() {
        let invalidHex = "ZZZZ"
        XCTAssertTrue(invalidHex.hexaData.isEmpty)
        XCTAssertTrue(invalidHex.hexaBytes.isEmpty)
    }
}
