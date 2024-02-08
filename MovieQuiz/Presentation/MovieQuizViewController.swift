import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate  {
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var myButtonYes: UIButton!
    @IBOutlet private var myButtonNo: UIButton!
    
    private var currentQuestionIndex = 0 // счетчик вопросов
    private var correctAnswers = 0     // счетчик правильных ответов
    private let questionsAmount: Int = 10 // общее количество вопросов
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion? // текущий вопрос
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self) // экземпляр класса AlertPresenter
    private var statisticService: StatisticService?
     
    
    // MARK: - Lifecycle
    override func viewDidLoad() { 
        super.viewDidLoad()
        questionFactory?.delegate = self // настройка делегата questionFactory
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self) // вызов метода для получения первого вопроса
        alertPresenter.delegate = self
        statisticService = StatisticServiceImplementation()
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        activityIndicator.startAnimating()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    // получении нового вопроса от questionFactory
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return } // проверка, что вопрос не nil
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.startAnimating()
        questionFactory?.requestNextQuestion()
        activityIndicator.stopAnimating()
    }
    
    // MARK: - AlertPresenterDelegate
    func alertDidShow(_ alertModel: AlertModel) {
        resetData()
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        myButtonYes.isEnabled = false
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        myButtonNo.isEnabled = false
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private functions
    private func enableButton() {
        myButtonYes.isEnabled = true
        myButtonNo.isEnabled = true
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        let alertActivity = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in
            guard let self = self else { return }
            self.resetData()
        })
        
        alertPresenter.showAlert(alertActivity)
    }
    
    private func resetData() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
        self.enableButton()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image) ?? UIImage()
        let questionNumber = "\(currentQuestionIndex + 1)/\(questionsAmount)"
        return QuizStepViewModel(image: image, question: model.text, questionNumber: questionNumber)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
     
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            imageView.layer.borderColor = UIColor.clear.cgColor
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: showFinalResults(),
                buttonText: "Сыграть еще раз",
                completion: { [weak self] in
                    guard let self = self else { return }
                    self.resetData()
                })
            
            alertPresenter.showAlert(alertModel)
            
        } else {
            currentQuestionIndex += 1
            imageView.layer.borderColor = UIColor.clear.cgColor
            questionFactory?.requestNextQuestion()
            enableButton()
        }
    }
    
    private func showFinalResults() -> String {
        
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
}

