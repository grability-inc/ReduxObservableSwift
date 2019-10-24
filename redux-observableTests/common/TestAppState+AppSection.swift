//
//  TestAppState.swift
//  ios-saas
//
//  Created by Camilo Ortegon on 10/9/19.
//  Copyright © 2019 Camilo Ortegon. All rights reserved.
//

import Foundation

enum Territory : String {
    case Venice
    case Karakorum
    case Yangzhou
    case Hormuz
}

struct TestAppState : Equatable {

    var conquestInfo : ConquestInfo = ConquestInfo()

    static func == (lhs: TestAppState, rhs: TestAppState) -> Bool {
        return lhs.conquestInfo == rhs.conquestInfo
    }

}

struct ConquestInfo : Equatable {

    var currentTerritory = Territory.Venice

    static func == (lhs: ConquestInfo, rhs: ConquestInfo) -> Bool {
        return lhs.currentTerritory == rhs.currentTerritory
    }

}
