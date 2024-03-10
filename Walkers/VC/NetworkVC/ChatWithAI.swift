//
//  TwoRoutes.swift
//  Walkers
//
//  Created by Кристина on 26.01.2024.
//
import UIKit
import MessageKit
import InputBarAccessoryView


class Chat: MessagesViewController, UITextFieldDelegate {
    let sender = Sender(senderId: "1", displayName: "Я")
    let us = Sender(senderId: "2", displayName: "Ты")
    var messages: [MessageType] = []
    private var models = [String]()
    
    var smessages: [Message] = []
    private let openAIService = OpenAIService()
    
    private let nc = NotificationCenter.default
    
    // MARK: - LifeCycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageSettings()

    }
    
    func messageSettings() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        maintainPositionOnKeyboardFrameChanged = true
        
        messageInputBar.sendButton.title = ""
        messageInputBar.sendButton.image = UIImage(named: "arrow_up")
       
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        showMessageTimestampOnSwipeLeft = true
    }
    
}

// MARK: - Extensions

extension Chat: MessagesDataSource {
    func currentSender() -> MessageKit.SenderType {
        return sender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension Chat: MessagesDisplayDelegate, MessagesLayoutDelegate {}

extension Chat: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        messages.append(MessageK(sender: sender, messageId: "1", sentDate: Date(), kind: .text(text)))
        messagesCollectionView.reloadData()
        let newMessage = Message(id: UUID(), role: .user, content: text, createAt: Date())
        self.smessages.append(newMessage)
        
        Task {
            let response = await self.openAIService.sendMessage(messages: self.smessages)
            guard let receivedOpenAIMessage = response?.choices.first?.message else {
                print( "Had no received message")
                return
            }
            let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
            print(receivedMessage)
            await MainActor.run {
                self.smessages.append(receivedMessage)
                
            }
            self.messages.append(MessageK(sender: self.us, messageId: "2", sentDate: Date(), kind: .text(receivedMessage.content)))
            messagesCollectionView.reloadData()
            
        }
        
        inputBar.inputTextView.text = nil
    }
    
}




