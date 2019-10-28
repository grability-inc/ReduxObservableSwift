//
//  ConquerorReducer.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

@testable import ReduxObservable

class ConquerorReducer: Reducer<TestAppState> {
    override func reduce(state: TestAppState, action: ReduxAction) -> TestAppState {
        var s = state
        if case let ExplorerAction.conquest(territory: territory) = action {
            s.conquestInfo.currentTerritory = territory
        }
        return s
    }
}
