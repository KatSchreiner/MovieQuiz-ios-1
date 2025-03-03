//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 26.01.2024.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int) 
}





