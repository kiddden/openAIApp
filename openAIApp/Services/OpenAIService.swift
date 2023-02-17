//
//  OpenAIService.swift
//  openAIApp
//
//  Created by Eugene Ned on 16.02.2023.
//

import Alamofire
import Combine

class OpenAIService {
    let baseURL = "https://api.openai.com/v1/completions"
    let APIKey = "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"
    
    func send(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: message, max_tokens: 2048, temperature: 0.5)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(APIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request(self.baseURL, method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAICompletionsResponse.self) { response in
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
}
