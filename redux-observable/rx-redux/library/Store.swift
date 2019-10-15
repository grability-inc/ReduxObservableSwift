//
//  Store.swift
//  ReduxExamples
//
//  Created by Camilo Ortegon on 10/9/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift

class Store<S> {

    let disposeBag = DisposeBag()
    let SerialQueue = DispatchQueue(label: "ReduxStore")

    var currentState: S
    let reactiveState = PublishSubject<S>()
    let actions = PublishSubject<ReduxAction>()
    var reducers = [Reducer<S>]()
    var middlewares = [Middleware<S>]()

    init(initialState: S) {
        self.currentState = initialState
        _ = actions.map { a in
            self.currentState = self.reducers.reduce(self.currentState) { $1.reduce(state: $0, action: a) }
            self.reactiveState.onNext(self.currentState)
        }.subscribe().disposed(by: disposeBag)
    }

    func dispatch(action: ReduxAction) {
        SerialQueue.async {
            objc_sync_enter(self)
            self.dispatchSync(action)
            objc_sync_exit(self)
        }
    }

    fileprivate func dispatchSync(_ action: ReduxAction) {
        middlewares.forEach {
            $0.dispatch(store: self, action: action)
        }
        actions.onNext(action)
    }

    public func state<Type>(_ keyPath: KeyPath<S, Type>) -> Observable<Type> {
        return mapProperty(keyPath)
            .distinctUntilChanged { "\($0)" == "\($1)" }
            .observeOn(MainScheduler.instance)
    }

    fileprivate func mapProperty<Type>(_ keyPath: KeyPath<S, Type>) -> Observable<Type> {
        return reactiveState
            .asObservable()
            .map { (state: S) -> Type in
                return state[keyPath: keyPath]
            }
            .observeOn(MainScheduler.instance)
    }

}
