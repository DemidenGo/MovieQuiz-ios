import UIKit

final class MovieQuizViewController: UIViewController {

    private let questionsAmount = 10
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var rightAnswerCounter = 0
    private var quizeCounter = 0
    private var bestQuizResult = (score: 0, date: "")
    private var currentDate: String { Date().dateTimeString }

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
        showFirstQuizStep()
    }

    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }

    private func showFirstQuizStep() {
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let firstQuizStep = convert(model: firstQuestion)
            show(quiz: firstQuizStep)
        }
    }

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

    private func show(quize result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            self?.currentQuestionIndex = 0
            self?.rightAnswerCounter = 0
            self?.showFirstQuizStep()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // конвертируем модель вопроса во вью модель для состояния "Вопрос задан"
        let image = UIImage(named: model.image)
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
            let quizeResultsModel = QuizResultsViewModel.makeModel(for: rightAnswerCounter, questionsAmount, quizeCounter, bestQuizResult)
            show(quize: quizeResultsModel)
        } else {
            // показываем следующий вопрос
            currentQuestionIndex += 1
            guard let nextQuestion = questionFactory.requestNextQuestion() else { return }
            currentQuestion = nextQuestion
            let currentQuizeStep = convert(model: nextQuestion)
            show(quiz: currentQuizeStep)
        }
    }

    private func calculateQuizResult() {
        quizeCounter += 1
        if rightAnswerCounter > bestQuizResult.score {
            bestQuizResult.score = rightAnswerCounter
            bestQuizResult.date = currentDate
        }
    }
}
