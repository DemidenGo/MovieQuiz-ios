//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 24.08.2022.
//
// сущность для взаимодействия с UserDefaults

import UIKit

final class StatisticServiceImplementation: StatisticServiceProtocol {
    var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date().dateTimeString)
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case totalAccuracy, gamesCount, bestGame
    }

    //метод сохранения лучшего результата игры
    func store(correct count: Int, total amount: Int) {
        bestGame.correct = count
        bestGame.total = amount
        bestGame.date = Date().dateTimeString
    }
}
