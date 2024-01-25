//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 17.01.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlert(_ alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
        
        delegate?.alertDidShow(alertModel)
    }

    }



//private func show(quiz result: QuizResultsViewModel) {
//    let alert = UIAlertController(
//        title: result.title,
//        message: result.text,
//        preferredStyle: .alert)
//    let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
//        self.currentQuestionIndex = 0 // сбрасываем правильные ответы и счетчик вопросов
//        self.correctAnswers = 0
//        self.questionFactory?.requestNextQuestion()
//        self.enableButton()
//    }
//    alert.addAction(action)
//    self.present(alert, animated: true, completion: nil)
