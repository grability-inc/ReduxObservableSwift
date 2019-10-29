//
//  Reducer.swift
//  ReduxExamples
//
//  Created by Camilo Ortegon on 10/9/19.
//  Copyright © 2019 Grability. All rights reserved.
//

open class Reducer<S> {

    public init() {
    }

    open func reduce(state: S, action: ReduxAction) -> S {
        return state
    }

}
