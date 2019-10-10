//
//  MarcoPoloEpic.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift
@testable import redux_observable

class MaffeoPoloEpic: Epic<TestAppState> {
    
    override func getObservable(for observable: Observable<ReduxAction>, store: Store<TestAppState>) -> Observable<ReduxAction> {
        return observable
            .of(actionIdentifier: TestAction.maffeoIdentifier)
            .do(onNext: { response in
                print("[Venezia] Maffeo Polo is here!")
                print("[Venezia] Maffeo Polo calling Marco")
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                    store.dispatch(action: TestAction.marco)
                }
            })
            .flatMap {_ -> Observable<ReduxAction> in
                return store.getOneTimeObserver(actionIdentifiers: [TestAction.poloIdentifier])
            }
            .do(onNext: { response in
                print("[Venezia] Maffeo Polo was called by the lastname")
            })
    }
}
