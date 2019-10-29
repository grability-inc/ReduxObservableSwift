//
//  MarcoPoloEpic.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift
@testable import ReduxObservable

class MarcoPoloEpic: Epic<TestAppState> {

    override func getObservable(for observable: Observable<ReduxAction>, store: Store<TestAppState>) -> Observable<ReduxAction> {
        return observable
            .of(actionIdentifier: TestAction.marcoIdentifier)
            .do(onNext: { response in
                print("[Venezia] Marco Polo is here!")
                print("[Venezia] Marco Polo calling his family")
                store.dispatch(action: TestAction.polo)
            })
            .flatMapToEmpty()
    }
}
