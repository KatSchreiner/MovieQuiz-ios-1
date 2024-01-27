//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 28.01.2024.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    var bestGame: GameRecord {
            get {
                guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let bestGame = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                    return .init(correct: 0, total: 0, date: Date())
                }
                return bestGame
            }
            set {
                guard let data = try? JSONEncoder().encode(newValue) else {
                    print("Невозможно сохранить результат")
                    return
                }
                userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }
        }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let newGameRecord = GameRecord(correct: count, total: amount, date: Date())
        
        let savedGameRecord = bestGame
        
        if newGameRecord.isBetterThan(lhs: newGameRecord, rhs: savedGameRecord) {
            bestGame = newGameRecord
        }
        
        correct = count
        total = amount
        gamesCount += 1
        
    }
}
