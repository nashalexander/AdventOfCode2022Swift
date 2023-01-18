//
//  Access.swift
//  AdventOfCode2022
//
//  Created by Alex on 1/15/23.
//

import Foundation

enum AdventMethod {
    case None
    case RuckSack
    case CampCleaning
    case RockPaperScissors
    case CalorieTracker
    case CargoStacks
    case SignalTransmitter
    case FileSystemParser
}

func executeAdvent(method : AdventMethod, files : [String]) -> String
{
    switch method {
    case .RuckSack:
        ruckSackCommonItemCalculator(files)
        return "Result is in the terminal"
    default:
        return "method \(method) execution not defined"
    }
}

