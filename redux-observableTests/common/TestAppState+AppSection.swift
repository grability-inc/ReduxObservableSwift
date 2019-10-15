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

class TestAppState {

    var conquestInfo : ConquestInfo = ConquestInfo()

}

class ConquestInfo {

    var currentTerritory = Territory.Venice

}
