//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 31.01.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
struct NetworkClient: NetworkRouting {

    private enum NetworkError: Error {
        case codeError
    }
    
    // функция, которая будет загружать что-то по заранее заданному URL
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        // Создаем запрос из url
        let request = URLRequest(url: url)
        
        // Пишем обработку ответа
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Распаковываем аргумент error. Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Распаковываем аргумент response. Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
  
