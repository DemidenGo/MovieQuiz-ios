import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    private var resultAlertPresenter: ResultAlertPresenterProtocol?
    private var errorAlertPresenter: ErrorAlertPresenterProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()


    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    private var currentQuestion: QuizQuestion?
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


    private let presenter = MovieQuizPresenter()
    private var bestQuizResult: GameRecord { statisticService.bestGame }

    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupDelegates()
        showLoadingIndicator()
        questionFactory?.loadData()
    }

    // MARK: - QuestionFactoryDelegate

    // Получен вопрос для квиза
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let quizStep = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.show(quiz: quizStep)
        }
    }

    // Данные успешно загружены
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    // Пришла ошибка от сервера
    func didFailToLoadData(with error: String, buttonAction: @escaping () -> Void) {
        activityIndicator.isHidden = true
        errorAlertPresenter?.showNetworkError(message: error) {
            buttonAction()
        }
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    // MARK: - Actions

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.check(userAnswer: true)
        disableUserInteractionForButtons()
        showNextQuestionOrResultWithDelay(seconds: 1)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.check(userAnswer: false)
        disableUserInteractionForButtons()
        showNextQuestionOrResultWithDelay(seconds: 1)
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

    func showNextQuestionOrResultWithDelay(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.showNextQuestionOrResult()
        }
    }

    func showAnswerResult(isCorrect: Bool) {
        // индикация правильности ответа
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    // MARK: - Private functions

    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }

    private func setupDelegates() {
        // Mock-данные для тестирования
        questionFactory = MockQuestionFactory(delegate: self)
        //questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        resultAlertPresenter = ResultAlertPresenter(viewController: self)
        errorAlertPresenter = ErrorAlertPresenter(viewController: self)
        presenter.viewController = self
    }

//    private func check(userAnswer: Bool) {
//        guard let currentQuestion = currentQuestion else { return }
//        if userAnswer == currentQuestion.correctAnswer {
//            showAnswerResult(isCorrect: true)
//            presenter.rightAnswer()
//        } else {
//            showAnswerResult(isCorrect: false)
//        }
//    }

    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        counterLabel.text = "\(step.questionNumber)/\(presenter.questionsAmount)"
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        enableUserInteractionForButtons()
    }

    private func show(quiz result: QuizResultsViewModel) {
        // показываем алерт с результатами пройденного квиза, готовим следующий раунд квиза
        resultAlertPresenter?.show(quiz: result) { [weak self] in
            self?.presenter.resetQuestionIndex()
            self?.presenter.resetRightAnswerCounnter()
            self?.questionFactory?.requestNextQuestion()
        }
    }

    private func showNextQuestionOrResult() {
        if presenter.isLastQuestion() {
            // вычисляем и показываем результат квиза
            calculateQuizResult()
            let quizResultsModel = QuizResultsViewModel.makeModel(for: presenter.getRightAnswers(),
                                                                  presenter.questionsAmount,
                                                                  statisticService.gamesCount,
                                                                  bestQuizResult,
                                                                  statisticService.totalAccuracy)
            show(quiz: quizResultsModel)
        } else {
            // показываем следующий вопрос
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }

    private func calculateQuizResult() {
        statisticService.gamesCount += 1
        if bestQuizResult.isWorseThan(currentQuizScore: presenter.getRightAnswers()) {
            statisticService.store(correct: presenter.getRightAnswers(), total: presenter.questionsAmount)
        }
        let currentAccuracy = round(Double(presenter.getRightAnswers()) / Double(presenter.questionsAmount) * 100)
        let gamesCount = Double(statisticService.gamesCount)
        let previousGamesCount = Double(statisticService.gamesCount - 1)
        let totalAccuracy = (statisticService.totalAccuracy * (previousGamesCount) + currentAccuracy) / gamesCount
        let totalAccuracyRounded = round(totalAccuracy * 100) / 100
        statisticService.totalAccuracy = totalAccuracyRounded
    }
}
