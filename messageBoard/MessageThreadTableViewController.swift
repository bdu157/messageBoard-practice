//
//  MessageThreadTableViewController.swift
//  messageBoard
//
//  Created by Dongwoo Pae on 6/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class MessageThreadTableViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var messageThreadController: MessageThreadController = MessageThreadController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageThreadController.messageThreads.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let indexPath = messageThreadController.messageThreads[indexPath.row]
        cell.textLabel?.text = indexPath.title
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCelltoDetailTableVC" {
            guard let destVC = segue.destination as? MessageThreadDetailTableViewController,
                let selectedRow = self.tableView.indexPathForSelectedRow else {return}
                destVC.messageThread = self.messageThreadController.messageThreads[selectedRow.row]
                destVC.messageThreadController = self.messageThreadController
            
        }
    }


    @IBAction func textFieldAction(_ sender: Any) {
        guard let input = textField.text else {return}
        messageThreadController.createMessageThread(title: input) { (error) in
            if let error = error {
                NSLog("print: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
    }
}
