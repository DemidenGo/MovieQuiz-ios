//
//  ResultAlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 23.08.2022.
//

import UIKit

protocol ResultAlertPresenterProtocol {
    func show(quiz result: QuizResultsViewModel, buttonAction: @escaping () -> Void)
}
