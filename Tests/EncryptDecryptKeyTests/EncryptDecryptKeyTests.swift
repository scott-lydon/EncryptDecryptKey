import XCTest
@testable import EncryptDecryptKey

struct TestStruct: Codable, Equatable {
    let name: String
    let age: Int
}

final class EncryptDecryptKeyTests: XCTestCase {

    func testEncryptDecryptData() throws {
            // Original data
            let originalString = "This is a test string."
            guard let originalData = originalString.data(using: .utf8) else {
                XCTFail("Failed to convert string to data")
                return
            }

            // Encrypt data
            let encryptedData = try originalData.encrypt()

            // Decrypt data
            let decryptedData = try encryptedData.decrypt()

            // Compare decrypted data to original
            XCTAssertEqual(decryptedData, originalData, "Decrypted data does not match original data")

            // Convert decrypted data back to string and compare
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            XCTAssertEqual(decryptedString, originalString, "Decrypted string does not match original string")
        }

        func testEncryptDecryptCodable() throws {
            // Original struct
            let originalStruct = TestStruct(name: "Test", age: 123)

            // Convert struct to data
            let originalData = try JSONEncoder().encode(originalStruct)

            // Encrypt data
            let encryptedData = try originalData.encrypt()

            // Decrypt data directly to struct
            let decryptedStruct: TestStruct = try encryptedData.decrypted()

            // Compare decrypted struct to original
            XCTAssertEqual(decryptedStruct, originalStruct, "Decrypted struct does not match original struct")
        }
}
