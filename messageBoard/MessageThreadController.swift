//
//  MessageThreadController.swift
//  messageBoard
//
//  Created by Dongwoo Pae on 6/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

class MessageThreadController {
    var messageThreads: [MessageThread] = []
    
    static let baseURL = URL(string: "https://message-board-b0673.firebaseio.com/")!
    
    func createMessageThread(title: String, completion:@escaping (Error?)->Void) {
        let messageThread = MessageThread(title: title)
        
        let createURL = MessageThreadController.baseURL.appendingPathComponent(messageThread.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: createURL)
        request.httpMethod = "PUT"
        
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let encodedData = try jsonEncoder.encode(messageThread)
            request.httpBody = encodedData
            completion(nil)
        } catch {
            NSLog("there is an error in encoding: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("there is an error in getting data: \(error)")
                completion(error)
                return
            }
            
            self.messageThreads.append(messageThread)
            completion(nil)
        }.resume()
    }
    
    func createMessage(messageThread: MessageThread, text: String, sender: String, completion: @escaping (Error?)-> Void) {
        let messages = MessageThread.Message(text: text, sender: sender)
        
        let messageURL = MessageThreadController.baseURL.appendingPathComponent(messageThread.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        
        var request = URLRequest(url: messageURL)
        request.httpMethod = "POST"
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let encodedData = try jsonEncoder.encode(messages)
            request.httpBody = encodedData
            completion(nil)
        } catch {
            NSLog("there is an error encoding data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("there is an error in uploding the data: \(error)")
                completion(error)
                return
            }
            
            messageThread.messages.append(messages)  //adding messages into same Thread by creating new using POST under same UUID().uuisString
            completion(nil)
            
            }.resume()
    }
    
    func fetchMessageThreads(completion: @escaping(Error?)-> Void) {
        let fetchURL = MessageThreadController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: fetchURL) { (data, _, error) in
            if let error = error {
                NSLog("there is an error:\(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("there is an error geting data")
                completion(error)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedData = try jsonDecoder.decode([String: MessageThread].self, from: data)
                self.messageThreads = decodedData.map {$0.value}
                completion(nil)
            } catch {
                NSLog("there is an error in decoding data")
                completion(error)
                return
            }
        }.resume()
    }
}
