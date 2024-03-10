//
//  OpenAiService.swift
//  Walkers
//
//  Created by Кристина on 29.02.2024.
//

import Foundation
import Alamofire

class OpenAIService {
    private let endpointUrl = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Constants.openAIApiKey)"]
        return try? await AF.request(endpointUrl, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}


