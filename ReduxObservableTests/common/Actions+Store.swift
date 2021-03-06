//
//  Action+State+Store.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

@testable import ReduxObservable

enum TestAction: ReduxAction {
    case marco
    case polo
    case niccolo
    case maffeo
    case niccoloAware
    case maffeoAware

    var identifier: String {
        switch self {
        case .marco: return TestAction.marcoIdentifier
        case .polo: return TestAction.poloIdentifier
        case .niccolo: return TestAction.niccoloIdentifier
        case .maffeo: return TestAction.maffeoIdentifier
        case .niccoloAware: return TestAction.niccoloAwareIdentifier
        case .maffeoAware: return TestAction.maffeoAwareIdentifier
        }
    }

    static let marcoIdentifier = "TestAction.marco"
    static let poloIdentifier = "TestAction.polo"
    static let niccoloIdentifier = "TestAction.niccolo"
    static let maffeoIdentifier = "TestAction.maffeo"
    static let niccoloAwareIdentifier = "TestAction.niccoloAware"
    static let maffeoAwareIdentifier = "TestAction.maffeoAware"
}

enum ExplorerAction: ReduxAction {
    case conquest(territory: Territory)

    var identifier: String {
        switch self {
        case .conquest: return ExplorerAction.conquestIdentifier
        }
    }

    static let conquestIdentifier = "ExplorerAction.conquest"
}

class TestAppStore: Store<TestAppState> {

    init(reducers: [Reducer<TestAppState>], middlewares: [Middleware<TestAppState>]) {
        super.init(initialState: TestAppState())
        self.reducers = reducers
        self.middlewares = middlewares
    }

}
