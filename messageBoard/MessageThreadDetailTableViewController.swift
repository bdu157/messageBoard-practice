//
//  MessageThreadDetailTableViewController.swift
//  messageBoard
//
//  Created by Dongwoo Pae on 6/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class MessageThreadDetailTableViewController: UITableViewController {
    
    var messageThread: MessageThread?
    var messageThreadController: MessageThreadController?
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.messageThreadController?.fetchMessageThreads(completion: { (error) in
            if let error = error {
                NSLog("there is an error: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.messageThread?.title
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThread?.messages.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        guard let indexPath = self.messageThread?.messages[indexPath.row] else {return UITableViewCell()}
        cell.textLabel?.text = indexPath.text
        cell.detailTextLabel?.text = indexPath.sender
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromMTDetailVCtoDetailVC" {
            guard let destVC = segue.destination as? MessageDetailViewController else {return}
                destVC.messageThread = self.messageThread
                destVC.messageThreadController = self.messageThreadController
        }
    }
}
