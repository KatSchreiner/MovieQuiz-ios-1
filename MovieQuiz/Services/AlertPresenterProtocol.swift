//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 25.01.2024.
//

import Foundation

protocol AlertPresenterProtocol {
    func showAlert(_ alertModel: AlertModel)
    var delegate: AlertPresenterDelegate? { get set }
}
 
