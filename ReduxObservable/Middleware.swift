//
//  Middleware.swift
//  ReduxExamples
//
//  Created by Camilo Ortegon on 10/9/19.
//  Copyright © 2019 Grability. All rights reserved.
//

open class Middleware<S: Equatable> {

    open func dispatch(store: Store<S>, action: ReduxAction) {
    }

}
