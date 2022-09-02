//
//  ErrorAlertPresenter.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 02.09.2022.
//

import UIKit

final class ErrorAlertPresenter: ErrorAlertPresenterProtocol {

    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showNetworkError(message: String, buttonAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Во время загрузки данных из сети что-то пошло не так:\n\(message)",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Попробовать ещё раз", style: .default) { _ in
            buttonAction()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
