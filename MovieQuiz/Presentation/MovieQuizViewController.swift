import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate  {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var myButtonYes: UIButton!
    @IBOutlet private var myButtonNo: UIButton!
    
    private var currentQuestionIndex = 0 // счетчик вопросов
    private var correctAnswers = 0     // счетчик правильных ответов
    private let questionsAmount: Int = 10 // общее количество вопросов
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory() // свойство с фабрикой вопросов
    private var currentQuestion: QuizQuestion? // текущий вопрос
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self) // экземпляр класса AlertPresenter
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.delegate = self // настройка делегата questionFactory
        questionFactory.requestNextQuestion() // вызов метода для получения первого вопроса
        alertPresenter.delegate = self
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
    
    // MARK: - AlertPresenterDelegate
    func alertDidShow(_ alertModel: AlertModel) {
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        self.questionFactory.requestNextQuestion()
        self.enableButton()
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
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage()
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
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
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
                message: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                buttonText: "Сыграть еще раз",
                completion: {})
            
            alertPresenter.showAlert(alertModel)

        } else {
            currentQuestionIndex += 1
            imageView.layer.borderColor = UIColor.clear.cgColor
            questionFactory.requestNextQuestion()
            enableButton()
        }
    }
    
}

