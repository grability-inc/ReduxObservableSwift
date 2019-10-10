//
//  Epic.swift
//  ReduxExamples
//
//  Created by Camilo Ortegon on 10/9/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift

class Epic<S> {

    private let actionRelay = PublishSubject<ReduxAction>()
    private var store : Store<S>!

    init() {
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

    func getObservable(for observable: Observable<ReduxAction>, store: Store<S>) -> Observable<ReduxAction> {
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

    func toMiddleware(_ store: Store<S>) -> Middleware<S> {
        self.store = store
        subscribeObservable()
        return EpicMiddleware(self)
    }

    func switchMap(actionIdentifiers types: [String]) -> Observable<ReduxAction> {
        return store.getOneTimeObserver(actionIdentifiers: types)
    }

}
