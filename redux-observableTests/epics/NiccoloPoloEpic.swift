//
//  MarcoPoloEpic.swift
//  redux-observableTests
//
//  Created by Camilo Ortegon on 10/10/19.
//  Copyright © 2019 Grability. All rights reserved.
//

import RxSwift
@testable import redux_observable

class NiccoloPoloEpic: Epic<TestAppState> {

    override func getObservable(for observable: Observable<ReduxAction>, store: Store<TestAppState>) -> Observable<ReduxAction> {
        return observable
            .of(actionIdentifier: TestAction.niccoloIdentifier)
            .do(onNext: { response in
                print("[Venezia] Niccolo Polo is here!")
                print("[Venezia] Niccolo Polo calling Marco")
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                    store.dispatch(action: TestAction.marco)
                }
            })
            .flatMap {_ -> Observable<ReduxAction> in
                return store.getOneTimeObserver(actionIdentifiers: [TestAction.poloIdentifier])
            }
            .do(onNext: { response in
                print("[Venezia] Niccolo Polo was called by the lastname")
            })
    }
}
