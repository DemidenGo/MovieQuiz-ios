import UIKit

final class MovieQuizViewController: UIViewController {

    private var questions: [QuizeQuestion] = QuizeQuestion.makeMockModel()
    private var currentQuestionIndex = 0
    private var rightAnswerCounter = 0
    private var quizeCounter = 0
    private var bestQuizResult = (score: 0, date: "")
    private var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return dateFormatter.string(from: Date())
    }

    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstQuestion = questions.first {
            let firstQuizeStep = convert(model: firstQuestion)
            show(quize: firstQuizeStep)
        }
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        if currentQuestion.correctAnswer {
            showAnswerResult(isCoorect: true)
            rightAnswerCounter += 1
        } else {
            showAnswerResult(isCoorect: false)
        }
        yesButton.isUserInteractionEnabled = false
        noButton.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showNextQuestionOrResult()
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        if !currentQuestion.correctAnswer {
            showAnswerResult(isCoorect: true)
            rightAnswerCounter += 1
        } else {
            showAnswerResult(isCoorect: false)
        }
        yesButton.isUserInteractionEnabled = false
        noButton.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showNextQuestionOrResult()
        }
    }

    private func show(quize step: QuizeStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        counterLabel.text = "\(step.questionNumber)/10"
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        textLabel.text = step.question
        yesButton.isUserInteractionEnabled = true
        noButton.isUserInteractionEnabled = true
    }

    private func show(quize result: QuizeResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
    }

    private func convert(model: QuizeQuestion) -> QuizeStepViewModel {
        let image = UIImage(named: model.image)
        let question = model.text
        let questionNumber = String(currentQuestionIndex + 1)
        return QuizeStepViewModel(image: image, question: question, questionNumber: questionNumber)
    }

    private func showAnswerResult(isCoorect: Bool) {
        if isCoorect {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            imageView.layer.cornerRadius = 20
        } else {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            imageView.layer.cornerRadius = 20
        }
    }

    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questions.count - 1 {
            // показываем результат квиза
            quizeCounter += 1
            if rightAnswerCounter > bestQuizResult.score {
                bestQuizResult.score = rightAnswerCounter
                bestQuizResult.date = currentDate
            }
            let quizeResultsModel = QuizeResultsViewModel.makeModel(for: rightAnswerCounter, quizeCounter, bestQuizResult)
            let alert = UIAlertController(title: quizeResultsModel.title,
                                          message: quizeResultsModel.text,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: quizeResultsModel.buttonText, style: .default) { _ in
                self.currentQuestionIndex = 0
                self.rightAnswerCounter = 0
                self.show(quize: self.convert(model: self.questions[0]))
            }
            alert.addAction(action)
            present(alert, animated: true)
        } else {
            // показываем следующий вопрос
            currentQuestionIndex += 1
            let currentQuestion = questions[currentQuestionIndex]
            let currentQuizeStep = convert(model: currentQuestion)
            show(quize: currentQuizeStep)

        }
    }
}

// MARK: - ViewModels

//модель для состояния "Вопрос задан"
struct QuizeStepViewModel {
    let image: UIImage?
    let question: String
    let questionNumber: String
}

//модель для состояния "Результат квиза"
struct QuizeResultsViewModel {
    let title: String
    let text: String
    let buttonText: String

    static func makeModel(for result: Int,
                          _ quizeCounter: Int,
                          _ bestQuize: (score: Int, date: String)) -> QuizeResultsViewModel {
        if result == 10 {
            return QuizeResultsViewModel(title: "Вы супер киноман!",
                                         text: "Все ответы верные! Такому знактоку надо работать в киноиндустрии. Сколько фильмов вы можете посмотреть в день?\nКоличество сыгранных квизов: \(quizeCounter)",
                                         buttonText: "Сыграть ещё раз")
        } else {
            return QuizeResultsViewModel(title: "Этот раунд окончен!",
                                         text: "Ваш результат: \(result)/10\nКоличество сыгранных квизов: \(quizeCounter)\nРекорд: \(bestQuize.score)/10 (\(bestQuize.date))\nСредняя точность: \(Double(result) / 10 * 100)%",
                                         buttonText: "Сыграть ещё раз")
        }
    }
}

// MARK: - MockDataModel

//модель вопроса
struct QuizeQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool

    static func makeMockModel() -> [QuizeQuestion] {
        var model = [QuizeQuestion]()

        model.append(QuizeQuestion(image: "The Godfather",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizeQuestion(image: "The Dark Knight",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizeQuestion(image: "Kill Bill",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizeQuestion(image: "The Avengers",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizeQuestion(image: "Deadpool",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizeQuestion(image: "The Green Knight",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: true))

        model.append(QuizeQuestion(image: "Old",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: false))

        model.append(QuizeQuestion(image: "The Ice Age Adventures of Buck Wild",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: false))

        model.append(QuizeQuestion(image: "Tesla",
                                   text: "Рейтинг этого фильма больше чем 6?",
                                   correctAnswer: false))

        model.append(QuizeQuestion(image: "Vivarium",
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
