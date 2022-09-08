import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    var errorAlertPresenter: ErrorAlertPresenterProtocol?
    private var resultAlertPresenter: ResultAlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        showLoadingIndicator()
        setupDelegates()
    }

    // MARK: - Actions

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.check(userAnswer: true)
        disableUserInteractionForButtons()
        presenter.showNextQuestionOrResultWithDelay(seconds: 1)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.check(userAnswer: false)
        disableUserInteractionForButtons()
        presenter.showNextQuestionOrResultWithDelay(seconds: 1)
    }

    // MARK: - Internal functions

    func disableUserInteractionForButtons() {
        yesButton.isUserInteractionEnabled = false
        noButton.isUserInteractionEnabled = false
    }

    func enableUserInteractionForButtons() {
        yesButton.isUserInteractionEnabled = true
        noButton.isUserInteractionEnabled = true
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }

    func showAnswerResult(isCorrect: Bool) {
        // индикация правильности ответа
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        counterLabel.text = "\(step.questionNumber)/\(presenter.questionsAmount)"
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        enableUserInteractionForButtons()
    }

    func show(quiz result: QuizResultsViewModel) {
        // показываем алерт с результатами пройденного квиза, готовим следующий раунд квиза
        resultAlertPresenter?.show(quiz: result) { [weak self] in
            self?.presenter.restartGame()
        }
    }

    // MARK: - Private functions

    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }

    private func setupDelegates() {
        presenter = MovieQuizPresenter(viewController: self)
        resultAlertPresenter = ResultAlertPresenter(viewController: self)
        errorAlertPresenter = ErrorAlertPresenter(viewController: self)
    }
}
