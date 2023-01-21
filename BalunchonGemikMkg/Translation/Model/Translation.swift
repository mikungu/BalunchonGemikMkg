//
//  Translation.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 10/01/23.
//

import Foundation
//The Struct Translation is of the type decodable
struct Translation: Decodable {
    //we have a constance which we are going to use in the following function to get the translation
    let data: [String: [Results]]
    //we return the text translated
    func returnTextTranslated() -> String {
        return data["translations"]![0].textIsTranslated
    }
}
//We have an another decodable struct Result with which we can use Translation with any problem
struct Results: Decodable {
    let textIsTranslated: String
    let languageSource: String
}
