//
//  AIMessageModel.swift
//  Walkers
//
//  Created by Никита Васильев on 02.03.2024.
//

import Foundation

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}
enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
