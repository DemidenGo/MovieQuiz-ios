//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 30.08.2022.
//
// Сетевой клиент - отвечает за загрузку данных по URL

import UIKit

// MARK: - NetworkRouterProtocol

protocol NetworkRouterProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - NetworkClient

struct NetworkClient: NetworkRouterProtocol {

    private enum NetworkError: Error {
        case codeError
    }

    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 && response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
