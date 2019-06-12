//
//  MessageDetailViewController.swift
//  messageBoard
//
//  Created by Dongwoo Pae on 6/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    var messageThread: MessageThread?
    var messageThreadController: MessageThreadController?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Messages"
   
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = textField.text,
            let message = textView.text,
            let messageThread = messageThread else {return}
        self.messageThreadController?.createMessage(messageThread: messageThread, text: message, sender: name, completion: { (error) in
            if let error = error {
                NSLog("there is an error in creating messages: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
