//
//  File.swift
//  EncryptDecryptKey
//
//  Created by Scott Lydon on 3/26/25.
//

import Foundation
import XCTest

class RandomBytesTests: XCTestCase {

    public func testZeroCountReturnsEmptyData() {
        let result: Data = .randomBytes(count: 0)
        XCTAssertEqual(result.count, 0, "Empty count should return empty Data")
        XCTAssertEqual(result, Data(), "Empty count should return empty Data")
    }

    public func testNegativeCountReturnsEmptyData() {
        let result: Data = .randomBytes(count: -1)
        XCTAssertEqual(result.count, 0, "Negative count should return empty Data")
        XCTAssertEqual(result, Data(), "Negative count should return empty Data")
    }

    public func testCorrectByteCount() {
        let byteCount = 16
        let result: Data = .randomBytes(count: byteCount)
        XCTAssertEqual(result.count, byteCount, "Result should contain requested number of bytes")
    }

    public func testRandomness() {
        let byteCount = 32
        let result1: Data = .randomBytes(count: byteCount)
        let result2: Data = .randomBytes(count: byteCount)

        // It's statistically extremely unlikely for two random generations
        // to produce identical results with sufficient byte count
        XCTAssertNotEqual(result1, result2, "Multiple generations should produce different results")
    }

    public func testByteRange() {
        let byteCount = 100
        let result: Data = .randomBytes(count: byteCount)

        // Verify all bytes are within valid range (0-255)
        for byte in result {
            XCTAssertGreaterThanOrEqual(byte, 0)
            XCTAssertLessThanOrEqual(byte, 255)
        }
    }

    public func testMultipleSizes() {
        let sizes = [1, 8, 64, 256]

        for size in sizes {
            let result: Data = .randomBytes(count: size)
            XCTAssertEqual(result.count, size, "Result should match requested size: \(size)")
        }
    }
}
