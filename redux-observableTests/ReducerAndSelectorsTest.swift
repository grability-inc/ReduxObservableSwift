//
//  ReducerAndSelectorsTest.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import XCTest
@testable import redux_observable

class ReducerAndSelectorsTest: XCTestCase {
    
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
    
    func testReducer() {
        
        //Given
        self.appStore?.reducers = [
            ConquerorReducer()
        ]
        
        //When
        dispatchGroup.enter()
        self.appStore?.dispatch(action: ExplorerAction.conquest(territory: Territory.Yangzhou))
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.dispatchGroup.leave()
        }
        
        //Then
        let expec = expectation(description: "Wait for redux dispatchs events")
        dispatchGroup.notify(queue: .global()) {
            XCTAssertEqual(Territory.Yangzhou, self.appStore?.currentState.currentTerritory)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 2)
    }

}
