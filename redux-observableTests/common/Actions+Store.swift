//
//  Action+State+Store.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

@testable import redux_observable

enum TestAction: ReduxAction {
    case marco
    case polo
    case niccolo
    case maffeo

    var identifier: String {
        switch self {
        case .marco: return TestAction.marcoIdentifier
        case .polo: return TestAction.poloIdentifier
        case .niccolo: return TestAction.niccoloIdentifier
        case .maffeo: return TestAction.maffeoIdentifier
        }
    }

    static let marcoIdentifier = "TestAction.marco"
    static let poloIdentifier = "TestAction.polo"
    static let niccoloIdentifier = "TestAction.niccolo"
    static let maffeoIdentifier = "TestAction.maffeo"
}

class TestAppStore: Store<TestAppState> {

    init(reducers: [Reducer<TestAppState>], middlewares: [Middleware<TestAppState>]) {
        super.init(initialState: TestAppState())
        self.reducers = reducers
        self.middlewares = middlewares
    }

}
