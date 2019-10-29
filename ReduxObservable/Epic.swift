//
//  Epic.swift
//  ReduxExamples
//
//  Created by Camilo Ortegon on 10/9/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift

open class Epic<S: Equatable> {

    private let actionRelay = PublishSubject<ReduxAction>()
    private var store : Store<S>!

    public init() {
    }

    private func subscribeObservable() {
        getObservable(
            for: actionRelay
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background)),
            store: self.store
        )
        .asObservable()
            .subscribe().disposed(by: store.disposeBag)
    }

    open func getObservable(for observable: Observable<ReduxAction>, store: Store<S>) -> Observable<ReduxAction> {
        return Observable.empty()
    }

    fileprivate class EpicMiddleware : Middleware<S> {
        var epic : Epic
        init(_ epic: Epic) {
            self.epic = epic
        }
        override func dispatch(store: Store<S>, action: ReduxAction) {
            self.epic.actionRelay.onNext(action)
        }
    }

    public func toMiddleware(_ store: Store<S>) -> Middleware<S> {
        self.store = store
        subscribeObservable()
        return EpicMiddleware(self)
    }

}
