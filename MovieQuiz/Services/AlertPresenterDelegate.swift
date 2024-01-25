//
//  AlertProtocol.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 23.01.2024.
//

import Foundation

protocol AlertProtocolDelegate: AnyObject {
    
    func showAlert(quiz result: QuizResultsViewModel)
    
}
