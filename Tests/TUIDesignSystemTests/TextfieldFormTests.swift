import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class TextfieldFormTests: XCTestCase {
    @MainActor func testScreenPaddingIsOwnedByFormAndCanBeDisabledWithoutChangingFieldInsets() async throws {
        var frames: [CGRect] = []
        for padding in [true, false] {
            let host = TUITextfieldTestHost(TUITextfieldForm(order: [.field("field")], screenPadding: padding) {
                TUITextfield(text: .constant("Value"), label: "Label").tuiTextfieldFormID("field")
            }, height: 300)
            defer { host.close() }
            await host.settle()
            let native = try XCTUnwrap(host.editor)
            frames.append(native.convert(native.bounds, to: host.view))
        }
        XCTAssertEqual(frames[0].minX, TUISpacing.x4 + TUISpacing.x3, accuracy: 0.5)
        XCTAssertEqual(frames[1].minX, TUISpacing.x3, accuracy: 0.5)
        XCTAssertEqual(frames[1].width - frames[0].width, 2 * TUISpacing.x4, accuracy: 0.5)
        XCTAssertEqual(frames[0].height, frames[1].height, accuracy: 0.5)
    }

    @MainActor func testActiveFieldBecomingReadOnlyRemovesKeyboardActionWithoutChangingItsState() async {
        let session = TUITextfieldFormSession(); session.order = [.field("a"), .field("b")]
        let first = TUITextfieldNativeEditor(); let second = TUITextfieldNativeEditor()
        var state = TUITextfieldState.focus
        let binding = Binding(get: { state }, set: { state = $0 })
        session.register(first, id: "a", state: binding, eligible: true)
        session.register(second, id: "b", state: .constant(.normal), eligible: true)
        session.began("a"); XCTAssertEqual(session.activeID, "a")
        state = .readOnly
        session.register(first, id: "a", state: binding, eligible: false)
        let refreshed = expectation(description: "Native update cycle completed")
        DispatchQueue.main.async { refreshed.fulfill() }
        await fulfillment(of: [refreshed], timeout: 1)
        XCTAssertNil(session.activeID)
        XCTAssertEqual(state, .readOnly)
        XCTAssertEqual(session.nextField(after: "a"), "b")
    }

    @MainActor func testContiguousNavigationSkipsUnavailableFieldsAndStopsAtBoundary() {
        let session = TUITextfieldFormSession()
        session.order = [.field("a"), .field("read"), .field("disabled"), .field("tap"),
                         .field("b"), .boundary, .field("c")]
        let editors = (0..<6).map { _ in TUITextfieldNativeEditor() }
        var states: [TUITextfieldState] = [.focus, .readOnly, .disabled, .normal, .invalid, .normal]
        let ids = ["a", "read", "disabled", "tap", "b", "c"]
        for i in ids.indices {
            session.register(editors[i], id: ids[i],
                state: Binding(get: { states[i] }, set: { states[i] = $0 }),
                eligible: states[i].isEditable && ids[i] != "tap")
        }
        XCTAssertEqual(session.nextField(after: "a"), "b")
        session.advance(from: "a")
        XCTAssertEqual(states[0], .normal); XCTAssertEqual(states[4], .invalidFocus)
        XCTAssertEqual(session.activeID, "b")
        XCTAssertTrue(session.hasFollowingField(after: "b"))
        XCTAssertNil(session.nextField(after: "b"))
        session.advance(from: "b")
        XCTAssertEqual(states[4], .invalid); XCTAssertEqual(states[5], .normal)
        XCTAssertNil(session.activeID)
        XCTAssertFalse(session.hasFollowingField(after: "c"))
        XCTAssertNil(session.nextField(after: "unknown"))
    }

    @MainActor func testNativeFrameScrollsOnlyWhenOccludedAndDoesNotRestartEveryFrame() {
        let session = TUITextfieldFormSession(); session.order = [.field("a")]
        let editor = TUITextfieldNativeEditor(); var state = TUITextfieldState.focus
        session.register(editor, id: "a", state: Binding(get: { state }, set: { state = $0 }), eligible: true)
        session.viewport = CGRect(x: 0, y: 0, width: 320, height: 300)
        var targets: [(String, UnitPoint)] = []
        session.scrollTo = { targets.append(($0, $1)) }
        session.updateFrame(CGRect(x: 16, y: 12, width: 300, height: 56), id: "a"); session.began("a")
        XCTAssertTrue(targets.isEmpty)
        session.updateFrame(CGRect(x: 16, y: 280, width: 300, height: 98), id: "a")
        XCTAssertEqual(targets.count, 1); XCTAssertEqual(targets[0].1, .bottom)
        session.updateFrame(CGRect(x: 16, y: 240, width: 300, height: 98), id: "a")
        XCTAssertEqual(targets.count, 1)
        session.viewport = CGRect(x: 0, y: 0, width: 320, height: 220); session.ensureVisible()
        XCTAssertEqual(targets.count, 2)
        session.viewport = CGRect(x: 0, y: 100, width: 320, height: 300)
        session.updateFrame(CGRect(x: 16, y: 80, width: 300, height: 56), id: "a")
        XCTAssertEqual(targets.count, 3); XCTAssertEqual(targets.last?.1, .top)
        session.dismiss(); XCTAssertNil(session.activeID); XCTAssertEqual(state, .normal)
    }

}
