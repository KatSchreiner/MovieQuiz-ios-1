//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 18.02.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showActivityIndicator()
    func hideActivityIndicator()
    func showNetworkError(message: String)
    func clearBorder()
    func enableButton()
}
