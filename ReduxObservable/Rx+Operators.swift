//
//  Rx+Operators.swift
//  ReduxExamples
//
//  Created by Camilo Ortegon on 10/9/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift

extension ObservableType where Element == ReduxAction {

    func of(actionIdentifier type: String) -> Observable<Element> {
        return of(actionIdentifiers: type)
    }

    func of(actionIdentifiers types: String...) -> Observable<Element> {
        return of(actionIdentifiers: types)
    }

    func of(actionIdentifiers types: [String]) -> Observable<Element> {
        return filter { return types.contains($0.identifier) }
    }

    func flatMapToEmpty() -> Observable<ReduxAction> {
        return flatMap { _ in Observable<ReduxAction>.never() }
    }

}

extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        return map { _ in () }
    }

}
