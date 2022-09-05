//
//  ResultAlertPresenter.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 23.08.2022.
//
// здесь мы показываем результат прохождения квиза

import UIKit

class ResultAlertPresenter: ResultAlertPresenterProtocol {

    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func show(quiz result: QuizResultsViewModel, buttonAction: @escaping () -> Void) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            buttonAction()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
