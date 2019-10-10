//
//  ConquerorReducer.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

@testable import redux_observable

class ConquerorReducer: Reducer<TestAppState> {
    override func reduce(state: TestAppState, action: ReduxAction) -> TestAppState {
        if case let ExplorerAction.conquest(territory: territory) = action {
            state.currentTerritory = territory
        }
        return state
    }
}
