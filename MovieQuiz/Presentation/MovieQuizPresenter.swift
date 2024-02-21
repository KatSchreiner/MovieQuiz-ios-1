//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 15.02.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
     
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService!
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.delegate = self 
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
    }
    
    func alertDidShow(_ alertModel: AlertModel) { resetData() }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didLoadDataFromServer() {
        viewController?.hideActivityIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
        image: UIImage(data: model.image) ?? UIImage(),
        question: model.text,
        questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            viewController?.clearBorder()
            viewController?.showAlertGameEnd()
        } else {
            self.switchToNextQuestion()
            
            viewController?.showActivityIndicator()
            questionFactory?.requestNextQuestion()
            viewController?.hideActivityIndicator()
            
            viewController?.clearBorder()
            viewController?.enableButton()
        }
    }
    
    func showFinalResults() -> String {
        guard let statisticService = statisticService as? StatisticServiceImplementation else {
            assertionFailure("Что-то пошло не так( \n невозможно загрузить данные")
            return ""
        }
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let resultMessage = """
        Ваш результат: \(correctAnswers)\\\(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(statisticService.correct)\\\(statisticService.total) (\(statisticService.bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        return resultMessage
    }
    
    func resetData() {
        restartGame()
        questionFactory?.requestNextQuestion()
        self.viewController?.enableButton()
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        
        if (isCorrect) { correctAnswers += 1 }
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self ] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
}
