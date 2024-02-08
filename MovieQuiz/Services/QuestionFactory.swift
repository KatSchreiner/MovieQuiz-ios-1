//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Екатерина Шрайнер on 16.01.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private var moviesLoader: MoviesLoading
    
    weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewControlle
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in // запускаем код в другом потоке
            // выбираем произвольный элемент из массива, чтобы показать его.
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            // создание данных из url
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.rezisedImageURL)
            } catch { // обрабатываем ошибку если загрузка пошла не по плану
                print("Failed to load image")
            }
            
            // Создаём вопрос, определяем его корректность и создаём модель вопроса
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
        
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
}
    
