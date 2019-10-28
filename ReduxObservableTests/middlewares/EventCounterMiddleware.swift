//
//  EventCounterMiddleware.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift
@testable import ReduxObservable

class EventCounterMiddleware: Middleware<TestAppState> {

    var count = 0
    var actionFilter : String
    let actionRelay = PublishSubject<String>()
    private let disposeBag = DisposeBag()

    init(_ filter: String) {
        self.actionFilter = filter
    }

    override func dispatch(store: Store<TestAppState>, action: ReduxAction) {
        if action.identifier == self.actionFilter {
            self.count += 1
        }
        actionRelay.onNext(action.identifier)
    }

    func debounce(interval: Int, _ callback: @escaping () -> Void) {
        actionRelay
            .asObserver()
            .debounce(RxTimeInterval.milliseconds(interval), scheduler: MainScheduler.instance)
            .subscribe { action in
                
                callback()
            }
            .disposed(by: disposeBag)
    }

}
