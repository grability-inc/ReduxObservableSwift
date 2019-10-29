//
//  Rx+Operators.swift
//  ReduxExamples
//
//  Created by Camilo Ortegon on 10/9/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift

public extension ObservableType where Element == ReduxAction {

    public func of(actionIdentifier type: String) -> Observable<Element> {
        return of(actionIdentifiers: type)
    }

    public func of(actionIdentifiers types: String...) -> Observable<Element> {
        return of(actionIdentifiers: types)
    }

    public func of(actionIdentifiers types: [String]) -> Observable<Element> {
        return filter { return types.contains($0.identifier) }
    }

    public func flatMapToEmpty() -> Observable<ReduxAction> {
        return flatMap { _ in Observable<ReduxAction>.never() }
    }

}

public extension ObservableType {

    public func mapToVoid() -> Observable<Void> {
        return map { _ in () }
    }

}
