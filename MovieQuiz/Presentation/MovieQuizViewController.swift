import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterDelegate  {

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var myButtonYes: UIButton!
    @IBOutlet private var myButtonNo: UIButton!
    
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self)
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() { 
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter.delegate = self
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        showActivityIndicator()
    }
    func alertDidShow(_ alertModel: AlertModel) {
        presenter.resetData()
    }
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        closedButton()
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        closedButton()
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    func enableButton() {
        myButtonYes.isEnabled = true
        myButtonNo.isEnabled = true
    }
    
    func closedButton() {
        myButtonNo.isEnabled = false
        myButtonYes.isEnabled = false
    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func clearBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if (isCorrectAnswer) {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
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
       
    func showAlertGameEnd() {
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: presenter.showFinalResults(),
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter.resetData()
            })
        alertPresenter.showAlert(alertModel)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
}

