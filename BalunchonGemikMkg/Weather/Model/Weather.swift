//
//  Weather.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 10/01/23.
//

import Foundation

struct Weather {
    //We only need here four properties for describing the weather:
    //the place where we wanna know. It's a string
    var place: String
    //the code of the weather conditions
    var codeWeather: Int
    //the degree or temperature
    var degree: Double
    //the representation image of sky which is a data
    var skyImage: Data
    //We implement the function which allows to describe or to interprate any code weather condition by using codeWeather as parameter to return a String
    func descriptionConditions (codeWeather: Int) -> String {
        switch codeWeather {
        case 200...202:
            return "Fortes pluies avec des orages"
        case 210...211:
            return "Risques d'orages"
        case 212...221:
            return "Orages violents et irréguliers"
        case 230...232:
            return "Orage avec bruine"
        case 300...321:
            return "Bruine pluie"
        case 500...504:
            return "Temps ensoleillé avec pluie"
        case 511:
            return "Pluie avec neige"
        case 520...531:
            return "Fortes pluies"
        case 600...622:
            return "Risque de Neige"
        case 701...781:
            return "Brouillards"
        case 800:
            return "Ciel dégagé"
        case 801...804:
            return "Temps nuageux"
        default:
            return "Conditions non signalées"
        }
    }
}
