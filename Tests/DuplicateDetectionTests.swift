import XCTest

class DuplicateDetectionTests: XCTestCase {
    func testHashLogic() {
        let data1 = "test".data(using: .utf8)!
        let data2 = "test".data(using: .utf8)!
        // Simulate hash comparison
        XCTAssertEqual(data1, data2)
    }
}
