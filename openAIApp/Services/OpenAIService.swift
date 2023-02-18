//
//  OpenAIService.swift
//  openAIApp
//
//  Created by Eugene Ned on 16.02.2023.
//

import Alamofire
import Combine
import UIKit

class OpenAIService {
    private let baseURL = "https://api.openai.com/v1/"
    private let APIKey = " "
    
    static let shared = OpenAIService()
    
    private init() {}
    
    func send(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: message, max_tokens: 2048, temperature: 0.5)
        print(APIKey)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(APIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request(self.baseURL+"completions", method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAICompletionsResponse.self) { response in
                print(response.data)
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func generateImage(forPrompt prompt: String) -> AnyPublisher<OpenAIImageGenResponse, Error> {
        let body = OpenAIImageGenBody(model: "image-alpha-001", prompt: prompt, response_format: "url")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(APIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request(self.baseURL+"images/generations", method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .responseDecodable(of: OpenAIImageGenResponse.self) { response in
                    print(response)
                    switch response.result {
                    case .success(let result):
                        promise(.success(result))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        AF.request(url).responseData { response in
            guard let data = response.value, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
}
