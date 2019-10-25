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

    func testSwitchMap() {
        
        //Given
        let eventRecorder = EventRecorderMiddleware()
        let expectedEvents : [ReduxAction] = [
            TestAction.niccolo,
            TestAction.marco,
            TestAction.polo,
            TestAction.niccoloAware,
            TestAction.maffeo,
            TestAction.marco,
            TestAction.polo,
            TestAction.maffeoAware
        ]
        self.appStore?.middlewares = [
            MarcoPoloEpic().toMiddleware(self.appStore!),
            NiccoloPoloEpic().toMiddleware(self.appStore!),
            MaffeoPoloEpic().toMiddleware(self.appStore!),
            eventRecorder
        ]
        
        //When
        self.dispatchGroup.enter()
        DispatchQueue.global().async {
            self.appStore?.dispatch(action: TestAction.niccolo)
        }
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            self.appStore?.dispatch(action: TestAction.maffeo)
        }
        
        //Then
        let expec = expectation(description: "Wait for redux dispatchs events")
        dispatchGroup.notify(queue: .global()) {
            let expected    = expectedEvents.reduce("") { $0 + "/" + $1.identifier }
            let identifiers = eventRecorder.actions.reduce("") { $0 + "/" + $1.identifier }
            XCTAssertEqual(identifiers, expected)
            expec.fulfill()
        }
        eventRecorder.debounce(interval: 2000) {
            self.dispatchGroup.leave()
        }
        
        wait(for: [expec], timeout: 7)
    }

}
