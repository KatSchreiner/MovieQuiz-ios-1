//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 16.01.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
}
 
