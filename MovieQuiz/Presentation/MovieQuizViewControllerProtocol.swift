//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 08.09.2022.
//
// Протокол для выполнения тестов MovieQuizPresenterTests

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {

    var errorAlertPresenter: ErrorAlertPresenterProtocol? { get set }

    func disableUserInteractionForButtons()
    func enableUserInteractionForButtons()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showAnswerResult(isCorrect: Bool)
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
}
