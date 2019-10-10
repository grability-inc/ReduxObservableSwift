//
//  EventCounterMiddleware.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift
@testable import redux_observable

class EventRecorderMiddleware: EventCounterMiddleware {

    var actions = [ReduxAction]()

    init() {
        super.init("")
    }

    override func dispatch(store: Store<TestAppState>, action: ReduxAction) {
        actions.append(action)
        actionRelay.onNext(action.identifier)
    }

}
