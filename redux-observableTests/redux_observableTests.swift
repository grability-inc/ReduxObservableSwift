//
//  redux_observableTests.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import XCTest
@testable import redux_observable

class redux_observableTests: XCTestCase {

    var appStore : TestAppStore? = nil
    var dispatchGroup = DispatchGroup()

    override func setUp() {
        self.dispatchGroup = DispatchGroup()
        self.appStore = TestAppStore(
            reducers: [],
            middlewares: []
        )
    }

    override func tearDown() {
    }

    func testMiddleware() {

        //Given
        let dispatchCount = 100
        let eventCounter = EventCounterMiddleware(TestAction.marcoIdentifier)
        self.appStore?.middlewares = [
            eventCounter
        ]

        //When
        self.dispatchGroup.enter()
        DispatchQueue.global().async {
            for _ in 1...100 {
                self.appStore?.dispatch(action: TestAction.marco)
            }
        }

        //Then
        let expec = expectation(description: "Wait for redux dispatchs events")
        dispatchGroup.notify(queue: .global()) {
            XCTAssertEqual(dispatchCount, eventCounter.count)
            expec.fulfill()
        }
        eventCounter.debounce(interval: 1000) {
            self.dispatchGroup.leave()
        }

        wait(for: [expec], timeout: 3)
    }

    func testEpic() {

        //Given
        let dispatchCount = 100
        let eventCounter = EventCounterMiddleware(TestAction.poloIdentifier)
        self.appStore?.middlewares = [
            eventCounter,
            MarcoPoloEpic().toMiddleware(self.appStore!)
        ]

        //When
        self.dispatchGroup.enter()
        DispatchQueue.global().async {
            for _ in 1...100 {
                self.appStore?.dispatch(action: TestAction.marco)
            }
        }

        //Then
        let expec = expectation(description: "Wait for redux dispatchs events")
        dispatchGroup.notify(queue: .global()) {
            XCTAssertEqual(dispatchCount, eventCounter.count)
            expec.fulfill()
        }
        eventCounter.debounce(interval: 1000) {
            self.dispatchGroup.leave()
        }

        wait(for: [expec], timeout: 3)
    }

}
