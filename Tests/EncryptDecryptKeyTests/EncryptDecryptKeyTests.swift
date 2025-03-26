



import XCTest
@testable import EncryptDecryptKey
import Crypto

struct TestStruct: Codable, Equatable {
    let name: String
    let age: Int
}

public extension SymmetricKey {
    // ✅ Shared testable key for consistent encryption/decryption
    static let testKey = SymmetricKey(size: .bits256)
}

final class EncryptDecryptKeyTests: XCTestCase {

    public func testEncryptDecryptData() throws {
        // Original data
        let originalString = "This is a test string."
        guard let originalData = originalString.data(using: .utf8) else {
            XCTFail("Failed to convert string to data")
            return
        }

        // Encrypt data
        let encryptedData = try originalData.encrypt(using: .testKey)

        // Decrypt data
        let decryptedData = try encryptedData.decrypt(using: .testKey)

        // Compare decrypted data to original
        XCTAssertEqual(decryptedData, originalData, "Decrypted data does not match original data")

        // Convert decrypted data back to string and compare
        let decryptedString = String(data: decryptedData, encoding: .utf8)
        XCTAssertEqual(decryptedString, originalString, "Decrypted string does not match original string")
    }

    public func testEncryptDecryptCodable() throws {
        // Original struct
        let originalStruct = TestStruct(name: "Test", age: 123)

        // Convert struct to data
        let originalData = try JSONEncoder().encode(originalStruct)

        // Encrypt data
        let encryptedData = try originalData.encrypt(using: .testKey)

        // Decrypt data directly to struct
        let decryptedStruct: TestStruct = try encryptedData.decrypted(using: .testKey)

        // Compare decrypted struct to original
        XCTAssertEqual(decryptedStruct, originalStruct, "Decrypted struct does not match original struct")
    }
}
