//
//  AlertProtocol.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 23.01.2024.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func alertDidShow(_ alertModel: AlertModel)
}
 
