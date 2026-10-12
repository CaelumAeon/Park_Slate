import XCTest

final class NavigationTests: XCTestCase {
    override func setUpWithError() throws { continueAfterFailure = false }

    func testDeniedPermissionStillOpensAtlasAndPersistsAwakening() {
        let app = launch(["--denied"])
        XCTAssertTrue(app.staticTexts["locationStatus"].label.contains("denied"))
        awaken(app)
        XCTAssertTrue(app.navigationBars["Atlas"].waitForExistence(timeout: 5))
        app.terminate()
        app.launchArguments = ["--ui-testing", "--denied"]
        app.launch()
        XCTAssertTrue(app.navigationBars["Atlas"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["awaken"].exists)
    }

    func testDemoDiscoveryCompendiumAndReturn() {
        let app = launch([])
        reveal(app.buttons["exploreDemo"], in: app)
        app.buttons["exploreDemo"].tap()
        XCTAssertTrue(app.navigationBars["Atlas"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["locationStatus"].label.contains("DEMO"))
        app.buttons["landmarks"].tap()
        app.buttons["Bethesda Terrace"].tap()
        XCTAssertTrue(app.staticTexts["discoveryNotice"].label.contains("Nothing is recorded"))
        app.buttons["readCompendium"].tap()
        XCTAssertTrue(app.navigationBars["Compendium Entry"].waitForExistence(timeout: 5))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Discovery Preview"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.buttons["Done"].tap()
        app.tabBars.buttons["Compendium"].tap()
        XCTAssertTrue(app.staticTexts["compendiumEmpty"].label.contains("No discoveries recorded"))
        app.tabBars.buttons["Atlas"].tap()
        app.buttons["demoToggle"].tap()
        XCTAssertTrue(app.buttons["awaken"].waitForExistence(timeout: 5))
        app.terminate()
        app.launchArguments = ["--ui-testing"]
        app.launch()
        XCTAssertTrue(app.buttons["awaken"].waitForExistence(timeout: 5))
    }

    func testApproximatePermissionNoticeAndCatalog() {
        let app = launch(["--approximate"])
        XCTAssertTrue(app.staticTexts["locationStatus"].label.contains("Approximate"))
        awaken(app)
        XCTAssertTrue(app.buttons["Open Settings"].exists)
        app.tabBars.buttons["Compendium"].tap()
        reveal(app.buttons["Bow Bridge"], in: app)
        app.buttons["Bow Bridge"].tap()
        XCTAssertTrue(app.navigationBars["Compendium Entry"].waitForExistence(timeout: 5))
    }

    func testLargeTypeAndReducedMotionCanNavigate() {
        let app = launch(["--accessibility", "--denied"])
        awaken(app)
        XCTAssertTrue(app.navigationBars["Atlas"].waitForExistence(timeout: 5))
        app.buttons["landmarks"].tap()
        reveal(app.buttons["Bow Bridge"], in: app)
        app.buttons["Bow Bridge"].tap()
        XCTAssertTrue(app.navigationBars["Discovery Preview"].waitForExistence(timeout: 5))
        reveal(app.buttons["readCompendium"], in: app)
        app.buttons["readCompendium"].tap()
        XCTAssertTrue(app.navigationBars["Compendium Entry"].waitForExistence(timeout: 5))
    }

    private func launch(_ arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--reset-state"] + arguments
        app.launch()
        XCTAssertTrue(app.buttons["exploreDemo"].waitForExistence(timeout: 5))
        return app
    }

    private func awaken(_ app: XCUIApplication) {
        let button = app.buttons["awaken"]
        let enabled = NSPredicate(format: "enabled == true")
        expectation(for: enabled, evaluatedWith: button)
        waitForExpectations(timeout: 8)
        reveal(button, in: app)
        button.tap()
    }

    private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<4 {
            if element.isHittable { return }
            app.swipeUp()
        }
        XCTAssertTrue(element.isHittable)
    }
}
