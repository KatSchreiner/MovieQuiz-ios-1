//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 17.01.2024.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showAlert(_ alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "showAlert"
        
        viewController?.present(alert, animated: true, completion: nil)
        
        delegate?.alertDidShow(alertModel)
    }
}
 
