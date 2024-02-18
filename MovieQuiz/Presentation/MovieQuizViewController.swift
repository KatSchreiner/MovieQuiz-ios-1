import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate  {
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var myButtonYes: UIButton!
    @IBOutlet private var myButtonNo: UIButton!
    
    lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self) // экземпляр класса AlertPresenter
//    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() { 
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter.delegate = self
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        activityIndicator.startAnimating()

    }
    
    // MARK: - AlertPresenterDelegate
    func alertDidShow(_ alertModel: AlertModel) {
        presenter.resetData()
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        myButtonYes.isEnabled = false
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        myButtonNo.isEnabled = false
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    func enableButton() {
        myButtonYes.isEnabled = true
        myButtonNo.isEnabled = true
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideActivityIndicator()
        let alertActivity = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in
            guard let self = self else { return }
            self.presenter.resetData()
        })
        
        alertPresenter.showAlert(alertActivity)
    }
    
//    private func resetData() {
//        presenter.resetQuestionIndex()
//        correctAnswers = 0
//        questionFactory?.requestNextQuestion()
//        self.enableButton()
//    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.presenter.showNextQuestionOrResults()
            
        }
    }
     
//    private func showNextQuestionOrResults() {
//        if presenter.isLastQuestion() {
//            imageView.layer.borderColor = UIColor.clear.cgColor
//            
//            let alertModel = AlertModel(
//                title: "Этот раунд окончен!",
//                message: showFinalResults(),
//                buttonText: "Сыграть еще раз",
//                completion: { [weak self] in
//                    guard let self = self else { return }
//                    self.resetData()
//                })
//            
//            alertPresenter.showAlert(alertModel)
//            
//        } else {
//            presenter.switchToNextQuestion()
//            imageView.layer.borderColor = UIColor.clear.cgColor
//            questionFactory?.requestNextQuestion()
//            enableButton()
//        }
//    }
    
//    private func showFinalResults() -> String {
//        
//        guard let statisticService = statisticService as? StatisticServiceImplementation else {
//            assertionFailure("Что-то пошло не так( \n невозможно загрузить данные")
//            return ""
//        }
//        
//        statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
//        
//        let resultMessage = """
//        Ваш результат: \(correctAnswers)\\\(presenter.questionsAmount)
//        Количество сыгранных квизов: \(statisticService.gamesCount)
//        Рекорд: \(statisticService.correct)\\\(statisticService.total) (\(statisticService.bestGame.date.dateTimeString))
//        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
//        """
//        return resultMessage
//    }
}

