import XCTest
@testable import CorePlayerEngine

final class PlayerPoolTests: XCTestCase {
    func testPrewarmCreatesEngine() async throws {
        let pool = PlayerPool()
        let mediaId = "test-id"
        let source = MediaSource(url: URL(string: "https://example.com/video.mp4")!, type: .auto)

        let ok = await pool.prewarm(mediaId: mediaId, source: source)

        XCTAssertTrue(ok, "prewarm should return true and create an engine")
        let managed = await pool.get(mediaId: mediaId)
        XCTAssertNotNil(managed)
    }
}
