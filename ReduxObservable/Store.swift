//
//  Store.swift
//  ReduxExamples
//
//  Created by Camilo Ortegon on 10/9/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift

public class NotValueTypeError: Error {
    var localizedDescription: String = "The mapped property is not a value type"
}

public class Store<S: Equatable> {

    let disposeBag = DisposeBag()
    let SerialQueue = DispatchQueue(label: "ReduxStore")

    var currentState: S
    let reactiveState : BehaviorSubject<S>!
    let actions = PublishSubject<ReduxAction>()
    var reducers = [Reducer<S>]()
    var middlewares = [Middleware<S>]()
    var oneTimeObservers = [String: PublishSubject<ReduxAction>]()

    init(initialState: S) {
        self.currentState = initialState
        self.reactiveState = BehaviorSubject<S>(value: currentState)
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
        for (_, value) in oneTimeObservers {
            value.onNext(action)
        }
        middlewares.forEach {
            $0.dispatch(store: self, action: action)
        }
        actions.onNext(action)
    }

    public func state<Type: Equatable>(_ keyPath: KeyPath<S, Type>) -> Observable<Type> {
        return mapProperty(keyPath)
            .flatMap { t -> Observable<Type> in
                if Mirror(reflecting: t).displayStyle == .class {
                    return Observable.error(NotValueTypeError())
                } else {
                    return Observable.just(t)
                }
            }
            .distinctUntilChanged { $0 == $1 }
    }

    public func state<Type>(_ keyPath: KeyPath<S, Type>) -> Observable<Type> {
        return mapProperty(keyPath)
            .distinctUntilChanged { "\($0)" == "\($1)" }
    }

    fileprivate func mapProperty<Type>(_ keyPath: KeyPath<S, Type>) -> Observable<Type> {
        return reactiveState
            .asObservable()
            .map { (state: S) -> Type in
                return state[keyPath: keyPath]
            }
    }

    func getOneTimeObserver(actionIdentifiers types: [String]) -> Observable<ReduxAction> {
        objc_sync_enter(self)
        let id = UUID().uuidString
        let subject = PublishSubject<ReduxAction>()
        self.oneTimeObservers[id] = subject
        let observer = subject.asObserver()
            .of(actionIdentifiers: types)
            .take(1)
            .do(onNext: { response in
                objc_sync_enter(self)
                self.oneTimeObservers.removeValue(forKey: id)
                objc_sync_exit(self)
            })
        objc_sync_exit(self)
        return observer
    }

}
