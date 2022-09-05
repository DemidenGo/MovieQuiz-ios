//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 22.08.2022.
//

import UIKit

class QuestionFactory: QuestionFactoryProtocol {

    // Mock-данные для следующего спринта
    //private var questions: [QuizQuestion] = QuizQuestion.makeMockModel()

    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoadable
    private var movies: [MostPopularMovie] = []

    init(delegate: QuestionFactoryDelegate, moviesLoader: MoviesLoadable) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }

    func requestNextQuestion() {
        // Запускаем код в другом потоке
        DispatchQueue.global().async { [weak self] in
            // Формируем модель QuizQuestion
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0

            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()

            do {
                // Во время загрузки постера показывваем индикатор в главном потоке
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.showLoadingIndicator()
                }
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                // Обрабатываем ошибку в главном потоке
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: error.localizedDescription) { [weak self] in
                        self?.delegate?.showLoadingIndicator()
                        self?.requestNextQuestion()
                    }
                }
            }

            let randomRating = Int.random(in: 1...9)
            let text = "Рейтинг этого фильма больше, чем \(randomRating)?"
            let rating = Float(movie.rating) ?? 0
            let correctAnswer = rating > Float(randomRating)
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            // Возвращаемся в главный поток и возвращаем вопрос через делегата
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
// Работа с mock-данными для следующего спринта
//        let index = (0..<questions.count).randomElement() ?? 0
//        let question = questions[safe: index]
//        delegate.didReceiveNextQuestion(question: question)
    }

    func loadData() {
        moviesLoader.loadMovies { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    if !mostPopularMovies.items.isEmpty || mostPopularMovies.errorMessage == "" {
                        self.movies = mostPopularMovies.items
                        self.delegate?.didLoadDataFromServer()
                    } else {
                        self.delegate?.didFailToLoadData(with: mostPopularMovies.errorMessage) { [weak self] in
                            self?.delegate?.showLoadingIndicator()
                            self?.loadData()
                        }
                    }
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error.localizedDescription) { [weak self] in
                        self?.delegate?.showLoadingIndicator()
                        self?.loadData()
                    }
                }
            }
        }
    }
}
