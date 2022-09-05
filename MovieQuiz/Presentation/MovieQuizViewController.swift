import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    private var resultAlertPresenter: ResultAlertPresenterProtocol?
    private var errorAlertPresenter: ErrorAlertPresenterProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    private var currentQuestion: QuizQuestion?
    private let questionsAmount = 10
    private var currentQuestionIndex = 0
    private var rightAnswerCounter = 0
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
        let quizStep = convert(model: question)
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
        check(userAnswer: true)
        disableUserInteractionForButtons()
        showNextQuestionOrResultWithDelay(seconds: 1)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        check(userAnswer: false)
        disableUserInteractionForButtons()
        showNextQuestionOrResultWithDelay(seconds: 1)
    }

    // MARK: - Private functions

    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }

    private func setupDelegates() {
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        resultAlertPresenter = ResultAlertPresenter(viewController: self)
        errorAlertPresenter = ErrorAlertPresenter(viewController: self)
    }

    private func check(userAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        if userAnswer == currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: true)
            rightAnswerCounter += 1
        } else {
            showAnswerResult(isCorrect: false)
        }
    }

    private func disableUserInteractionForButtons() {
        yesButton.isUserInteractionEnabled = false
        noButton.isUserInteractionEnabled = false
    }

    private func enableUserInteractionForButtons() {
        yesButton.isUserInteractionEnabled = true
        noButton.isUserInteractionEnabled = true
    }

    private func showNextQuestionOrResultWithDelay(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.showNextQuestionOrResult()
        }
    }

    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        counterLabel.text = "\(step.questionNumber)/\(questionsAmount)"
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        enableUserInteractionForButtons()
    }

    private func show(quiz result: QuizResultsViewModel) {
        // показываем алерт с результатами пройденного квиза, готовим следующий раунд квиза
        resultAlertPresenter?.show(quiz: result) { [weak self] in
            self?.currentQuestionIndex = 0
            self?.rightAnswerCounter = 0
            self?.questionFactory?.requestNextQuestion()
        }
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // конвертируем модель вопроса во вью модель для состояния "Вопрос задан"
        let image = UIImage(data: model.image)
        let question = model.text
        let questionNumber = String(currentQuestionIndex + 1)
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
    }

    private func showAnswerResult(isCorrect: Bool) {
        // индикация правильности ответа
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionsAmount - 1 {
            // вычисляем и показываем результат квиза
            calculateQuizResult()
            let quizResultsModel = QuizResultsViewModel.makeModel(for: rightAnswerCounter,
                                                                  questionsAmount,
                                                                  statisticService.gamesCount,
                                                                  bestQuizResult,
                                                                  statisticService.totalAccuracy)
            show(quiz: quizResultsModel)
        } else {
            // показываем следующий вопрос
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    private func calculateQuizResult() {
        statisticService.gamesCount += 1
        if bestQuizResult.isWorseThan(currentQuizScore: rightAnswerCounter) {
            statisticService.store(correct: rightAnswerCounter, total: questionsAmount)
        }
        let currentAccuracy = round(Double(rightAnswerCounter) / Double(questionsAmount) * 100)
        let gamesCount = Double(statisticService.gamesCount)
        let previousGamesCount = Double(statisticService.gamesCount - 1)
        let totalAccuracy = (statisticService.totalAccuracy * (previousGamesCount) + currentAccuracy) / gamesCount
        let totalAccuracyRounded = round(totalAccuracy * 100) / 100
        statisticService.totalAccuracy = totalAccuracyRounded
    }
}
