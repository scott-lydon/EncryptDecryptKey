//
//  File.swift
//  EncryptDecryptKey
//
//  Created by Scott Lydon on 3/25/25.
//
import XCTest
import Crypto
@testable import EncryptDecryptKey  // Replace with your module name

struct TestModel: Codable, Equatable {
    let name: String
    let age: Int
}

final class DataCryptoTests: XCTestCase {

    // Helper to generate a valid key
    private func generateKey() -> SymmetricKey {
        SymmetricKey(size: .bits256)
    }

    public func testEncryptDecryptRawDataWithKey() throws {
        let key = generateKey()
        let original = "Hello, World!".data(using: .utf8)!
        let encrypted = try original.encrypt(using: key)
        let decrypted = try encrypted.decrypt(using: key)
        XCTAssertEqual(decrypted, original)
    }

    public func testEncryptDecryptCodableWithKey() throws {
        let key = generateKey()
        let model = TestModel(name: "Alice", age: 30)
        let jsonData = try JSONEncoder().encode(model)
        let encrypted = try jsonData.encrypt(using: key)
        let decryptedModel: TestModel = try encrypted.decrypted(using: key)
        XCTAssertEqual(decryptedModel, model)
    }

    public func testEncryptDecryptRawDataWithoutKeyThrowsUnassigned() throws {
        // `theKey()` must be mocked or guaranteed to return a working key
        let original = "Hello, default key!".data(using: .utf8)!
        XCTAssertThrowsError(try original.encrypt())
    }

    public func testEncryptDecryptRawDataWithoutKey() throws {
        // `theKey()` must be mocked or guaranteed to return a working key
        let original = "Hello, default key!".data(using: .utf8)!
        theNonce = (0..<32).map { _ in UInt8.random(in: 0...255) }
        let encrypted: Data = try original.encrypt()  // nil key
        let decrypted: Data = try encrypted.decrypt()
        theNonce = []
        XCTAssertEqual(decrypted, original)
    }

    public func testDecryptWithWrongKeyThrows() throws {
        let original = "Sensitive Data".data(using: .utf8)!
        let key1 = generateKey()
        let key2 = generateKey()
        let encrypted = try original.encrypt(using: key1)

        XCTAssertThrowsError(try encrypted.decrypt(using: key2)) { error in
            print("Expected decryption failure: \(error)")
        }
    }

    public func testDecryptCorruptedDataThrows() throws {
        let original = "Corrupt me".data(using: .utf8)!
        let key = generateKey()
        var encrypted = try original.encrypt(using: key)

        // Corrupt the data
        encrypted[0] ^= 0xFF

        XCTAssertThrowsError(try encrypted.decrypt(using: key)) { error in
            print("Expected corruption failure: \(error)")
        }
    }

    public func testDecryptedCodableThrowsOnInvalidJSON() throws {
        let key = generateKey()
        let original = "Non-JSON Data".data(using: .utf8)!
        let encrypted = try original.encrypt(using: key)

        XCTAssertThrowsError(try encrypted.decrypted(using: key) as TestModel) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }

    public func testDataCombined() {
        do {
            let _ = try "Corrupt me".data(using: .utf8)!.encrypt(using: .theKey())
            XCTFail()
        } catch {

        }
    }

    public func testBufferEqualsKey() {
        do {
            let _: Data = try "Corrupt me".encrypted(using: .theKey(nonce: [1, 2]))
            XCTFail()
        } catch {

        }
    }
}

/*

 public extension Data {

     public func encrypt(using key: SymmetricKey? = nil) throws -> Data {
         var buffer: SymmetricKey
         if let key {
             buffer = key
         } else {
             buffer = try .theKey()
         }
         let sealedBox = try AES.GCM.seal(self, using: buffer)
         guard let combined = sealedBox.combined else {
             throw NSError(
                 domain: "EncryptDecryptKey",
                 code: -1,
                 userInfo: [NSLocalizedDescriptionKey: "Failed to get combined data"]
             )
         }
         return combined
     }

     public func decrypt(using key: SymmetricKey? = nil) throws -> Data {
         let sealedBox = try AES.GCM.SealedBox(combined: self)
         var buffer: SymmetricKey
         if let key {
             buffer = key
         } else {
             buffer = try .theKey()
         }
         return try AES.GCM.open(sealedBox, using: buffer)
     }
 */
