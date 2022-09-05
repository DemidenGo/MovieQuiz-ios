//
//  ErrorAlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 02.09.2022.
//

import UIKit

protocol ErrorAlertPresenterProtocol {
    func showNetworkError(message: String, buttonAction: @escaping () -> Void)
}
