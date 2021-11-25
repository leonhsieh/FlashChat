//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
//import Foundation

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()

    var messages: [Message] = [] //使用Message.swift的data type
    var listener: ListenerRegistration? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        將dataSource設定為self，會觸發UITableViewDataSource，發送request
        tableView.dataSource = self
        title = K.appname
        navigationItem.hidesBackButton = true//使用程式隱藏「Back」按鈕，日後方便管理，不用重拉
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()

    }
    
    func loadMessages() {
        listener = db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { [self] (querySnapshot, error) in
                
            self.messages = []
                
            if let e = error{
                print("Have issue about get documents from Firestore \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    
                    for doc in snapshotDocument {
                        
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageBody = data[K.FStore.bodyField] as? String{
                            
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,
           let messageSender = Auth.auth().currentUser?.email{
//            self.messageTextfield.text = ""
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error{
                    print("Problem with saving data to Firestore, \(e)")
                } else {
//                    clear messageTextfield's text in main queue
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    print("Suceeeful saving data.")
                }
            }
        }
    }
    
//    Must detach listener before implement logout
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        //first: remove/deacitve the listener
        if let safeListener = listener {
            safeListener.remove()
        }
        //now you can signout safely
    do {
      try Auth.auth().signOut()
        print("Implement Logout")
        navigationController?.popToRootViewController(animated: true)//back to RootViewController, which is welcome page
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
      
    }
    
}

//UITableViewDataSource：would send a request of data when tableView is loaded
extension ChatViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print(#function)
    
    // create a new constant as messages array's delegate
    let message = messages [indexPath.row]
    
//    Let input text can displayed in cell.
//    insert cell into table view
    let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
    cell.label.text = message.body

//    Current user's messages
    if message.sender == Auth.auth().currentUser?.email{
        cell.leftImageView.isHidden = true
        cell.rightImageView.isHidden = false
        cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
        cell.label.textColor = UIColor(named: K.BrandColors.purple)
//    Other user's messages
    } else {
        cell.leftImageView.isHidden = false
        cell.rightImageView.isHidden = true
        cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
        cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
    }
    return cell
}
}

