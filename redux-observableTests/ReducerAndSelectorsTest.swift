//
//  ReducerAndSelectorsTest.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import XCTest
import RxSwift
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
            XCTAssertEqual(Territory.Yangzhou, self.appStore?.currentState.conquestInfo.currentTerritory)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 2)
    }

    func testSelectorPointingProperty() {
        
        //Given
        self.appStore?.reducers = [
            ConquerorReducer()
        ]
        let expectedTerritories : [Territory] = [
            Territory.Yangzhou,
            Territory.Hormuz
        ]
        var territories : [Territory] = []
        
        //When
        dispatchGroup.enter()
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.appStore?.dispatch(action: ExplorerAction.conquest(territory: Territory.Yangzhou))
            self.appStore?.dispatch(action: ExplorerAction.conquest(territory: Territory.Hormuz))
            self.appStore?.dispatch(action: TestAction.marco)
        }
        appStore?.state(\.conquestInfo.currentTerritory)
            .subscribe(onNext: { [weak self] info in
                territories.append(info)
            })
            .disposed(by: appStore!.disposeBag)
        appStore?.state(\.conquestInfo.currentTerritory)
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { action in
                self.dispatchGroup.leave()
        }
        
        //Then
        let expec = expectation(description: "Wait for redux dispatchs events")
        dispatchGroup.notify(queue: .global()) {
            let expected    = expectedTerritories.reduce("") { $0 + "/\($1)" }
            let received    = territories.reduce("") { $0 + "/\($1)" }
            XCTAssertEqual(received, expected)
            expec.fulfill()
        }
        
        wait(for: [expec], timeout: 3)
    }

}
