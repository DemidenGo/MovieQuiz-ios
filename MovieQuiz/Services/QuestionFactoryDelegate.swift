//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 23.08.2022.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: String, buttonAction: @escaping () -> Void)
    func showLoadingIndicator()
}
