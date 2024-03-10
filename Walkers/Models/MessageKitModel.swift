//
//  MessageKitModel.swift
//  Walkers
//
//  Created by Никита Васильев on 02.03.2024.
//

import Foundation
import MessageKit

struct MessageK: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
