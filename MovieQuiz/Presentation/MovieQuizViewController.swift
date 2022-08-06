import UIKit

final class MovieQuizViewController: UIViewController {

    private var questions: [QuizQuestion] = QuizQuestion.makeMockModel()
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
        customizeImageView()
        if let firstQuestion = questions.first {
            let firstQuizeStep = convert(model: firstQuestion)
            show(quize: firstQuizeStep)
        }
    }

    private func customizeImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
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
        let currentQuestion = questions[currentQuestionIndex]
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

    private func showNextQuestionOrResultWithDelay (seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.showNextQuestionOrResult()
        }
    }

    private func show(quize step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        counterLabel.text = "\(step.questionNumber)/10"
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
            self?.show(quize: self!.convert(model: self!.questions[0]))
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
        guard isCorrect else { imageView.layer.borderColor = UIColor.ypRed.cgColor; return }
        imageView.layer.borderColor = UIColor.ypGreen.cgColor
    }

    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questions.count - 1 {
            // вычисляем и показываем результат квиза
            calculateQuizResult()
            let quizeResultsModel = QuizResultsViewModel.makeModel(for: rightAnswerCounter, quizeCounter, bestQuizResult)
            show(quize: quizeResultsModel)
        } else {
            // показываем следующий вопрос
            currentQuestionIndex += 1
            let currentQuestion = questions[currentQuestionIndex]
            let currentQuizeStep = convert(model: currentQuestion)
            show(quize: currentQuizeStep)
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

// MARK: - ViewModels

// модель для состояния "Вопрос задан"
struct QuizStepViewModel {
    let image: UIImage?
    let question: String
    let questionNumber: String
}

// модель для состояния "Результат квиза"
struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String

    static func makeModel(for result: Int,
                          _ quizeCounter: Int,
                          _ bestQuize: (score: Int, date: String)) -> QuizResultsViewModel {
        if result == 10 {
            return QuizResultsViewModel(title: "Вы супер киноман!",
                                         text: "Все ответы верные! Такому знактоку надо работать в киноиндустрии. Сколько фильмов вы можете посмотреть в день?\nКоличество сыгранных квизов: \(quizeCounter)",
                                         buttonText: "Сыграть ещё раз")
        } else {
            return QuizResultsViewModel(title: "Этот раунд окончен!",
                                         text: "Ваш результат: \(result)/10\nКоличество сыгранных квизов: \(quizeCounter)\nРекорд: \(bestQuize.score)/10 (\(bestQuize.date))\nСредняя точность: \(Double(result) / 10 * 100)%",
                                         buttonText: "Сыграть ещё раз")
        }
    }
}

// MARK: - MockDataModel

// модель вопроса
struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool

    static func makeMockModel() -> [QuizQuestion] {
        var model = [QuizQuestion]()

        model.append(QuizQuestion(image: "The Godfather",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizQuestion(image: "The Dark Knight",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizQuestion(image: "Kill Bill",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizQuestion(image: "The Avengers",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizQuestion(image: "Deadpool",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizQuestion(image: "The Green Knight",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizQuestion(image: "Old",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: false))

        model.append(QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: false))

        model.append(QuizQuestion(image: "Tesla",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: false))

        model.append(QuizQuestion(image: "Vivarium",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: false))
        return model
    }
}

/*
 Mock-данные


 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
