//
//  RockPaperScissors.swift
//  AdventOfCode2022
//
//  Created by Alex on 12/6/22.
//

import Foundation

enum RpsHand
{
    case rock
    case paper
    case scissors
}

enum GameResult
{
    case win
    case lose
    case tie
}

let rpsWinTable : Dictionary =
[
    RpsHand.rock : RpsHand.paper,
    RpsHand.paper : RpsHand.scissors,
    RpsHand.scissors : RpsHand.rock
]

extension Dictionary where Value: Equatable {
    func key(forValue value: Value) -> Key? {
        return first { $0.1 == value }?.0
    }
}

func getHand(_ hand: RpsHand, _ result: GameResult) -> RpsHand
{
    if(result == GameResult.tie)
    {
        return hand
    }
    
    var desiredHand : RpsHand
    if(result == GameResult.win)
    {
        desiredHand = rpsWinTable[hand]!
    }
    else
    {
        desiredHand = rpsWinTable.key(forValue: hand)!
    }
    
    return desiredHand
}

func getHandScore(_ hand: RpsHand) -> Int
{
    var score = 0
    switch(hand)
    {
    case RpsHand.rock:
        score += 1
    case RpsHand.paper:
        score += 2
    case RpsHand.scissors:
        score += 3
    }
    return score
}

func getMatchScores(_ round: (RpsHand, RpsHand)) -> (Int, Int)
{
    var resultForP1 : GameResult
    
    if(round.0 == round.1)
    {
        resultForP1 = GameResult.tie
    }
    else
    {
        switch(round.0)
        {
        case RpsHand.rock:
            switch(round.1)
            {
            case RpsHand.paper:
                resultForP1 = GameResult.lose
            case RpsHand.scissors:
                resultForP1 = GameResult.win
            case RpsHand.rock:
                print("should never happen")
                exit(1)
            }
        case RpsHand.paper:
            switch(round.1)
            {
            case RpsHand.rock:
                resultForP1 = GameResult.win
            case RpsHand.scissors:
                resultForP1 = GameResult.lose
            case RpsHand.paper:
                print("should never happen")
                exit(1)
            }
        case RpsHand.scissors:
            switch(round.1)
            {
            case RpsHand.rock:
                resultForP1 = GameResult.lose
            case RpsHand.paper:
                resultForP1 = GameResult.win
            case RpsHand.scissors:
                print("should never happen")
                exit(1)
            }
        }
    }
    
    var score : (Int, Int)
    
    switch(resultForP1)
    {
    case GameResult.win:
        score = (6, 0)
    case GameResult.tie:
        score = (3, 3)
    case GameResult.lose:
        score = (0, 6)
    }
    
    return score
}

func getScore(_ round: (RpsHand, RpsHand)) -> (Int, Int)
{
    var scores = getMatchScores(round)
    
    scores.0 += getHandScore(round.0)
    scores.1 += getHandScore(round.1)
    
    return scores
}

class MatchList
{
    var matches : [(RpsHand, RpsHand)] = []
    
    func totalPoints() -> (Int, Int)
    {
        var totalScores = (0, 0)
        for round in matches
        {
            let score = getScore(round)
            totalScores.0 += score.0
            totalScores.1 += score.1
        }
        return totalScores
    }
}

func createRpsMatchList(_ filename: String) -> MatchList?
{
    guard let file = freopen(filename, "r", stdin) else {
        print("Cannot open file")
        return nil
    }
    defer {
        fclose(file)
    }
    
    let matchList = MatchList()
    while let line : String = readLine()
    {
        var round : (RpsHand, RpsHand)
        let charArray = line.components(separatedBy: " ")
        switch(charArray[0])
        {
        case "A":
            round.0 = RpsHand.rock
        case "B":
            round.0 = RpsHand.paper
        case "C":
            round.0 = RpsHand.scissors
        default:
            print("Error in line: \(line)")
            return nil
        }
        switch(charArray[1])
        {
        case "X":
            round.1 = getHand(round.0, GameResult.lose)
        case "Y":
            round.1 = getHand(round.0, GameResult.tie)
        case "Z":
            round.1 = getHand(round.0, GameResult.win)
        default:
            print("Error in line: \(line)")
            return nil
        }
        matchList.matches.append(round)
    }

    return matchList
}

func rpsPointCalculator(_ files: [String])
{
    for file in files
    {
        print("Parsing file: \(file)")
        guard let matchList = createRpsMatchList(file) else
        {
            print("could not generate match list")
            continue
        }
        
        let score = matchList.totalPoints()
        
        print("The total score of player 1 will be: \(score.0)")
        print("The total score of player 2 will be: \(score.1)")
    }
}
