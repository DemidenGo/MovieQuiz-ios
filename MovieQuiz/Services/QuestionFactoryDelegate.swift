//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Юрий Демиденко on 23.08.2022.
//

import UIKit

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    
}
