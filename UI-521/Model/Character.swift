//
//  Character.swift
//  UI-521
//
//  Created by nyannyan0328 on 2022/03/28.
//

import SwiftUI

struct Character: Identifiable,Hashable,Equatable {
    var id = UUID().uuidString
    var value : String
    var padding : CGFloat = 10
    var textSize : CGFloat = .zero
    var fontSize : CGFloat = 20
    var isShowing : Bool = false
}

var characters_: [Character] = [

    Character(value: "Jacob"),
    Character(value: "Degrom"),
    Character(value: "is"),
    Character(value: "Highr"),
    Character(value: "Level"),
    Character(value: "Mlb"),
    Character(value: "Pitcher"),
    Character(value: "The"),
    Character(value: "Most"),
]



