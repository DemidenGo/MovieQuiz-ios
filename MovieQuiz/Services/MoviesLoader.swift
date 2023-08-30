//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 30.08.2022.
//
// Загрузчик фильмов - вызывает сетевого клиента и обрабатывает ответ от него

import UIKit

// MARK: - MoviesLoadable protocol

protocol MoviesLoadable {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoadable {

    // MARK: - NetworkClient

    private let networkClient: NetworkRouterProtocol

    init(networkClient: NetworkRouterProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    // MARK: - URL

    private var mostPopularMoviesURL: URL {
        guard let url = URL(string: Constants.baseURL + Constants.resourceURL + Constants.apiKey) else {
            preconditionFailure("Unable to construct mostPopularMoviesURL")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesURL) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            }
        }
    }
}
