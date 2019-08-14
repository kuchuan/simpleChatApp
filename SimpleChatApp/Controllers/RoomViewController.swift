//
//  RoomViewController.swift
//  SimpleChatApp
//
//  Created by 堀川浩二 on 2019/08/09.
//  Copyright © 2019 堀川浩二. All rights reserved.
//

import UIKit
import Firebase

class RoomViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    //どの部屋かを特定するためのドキュメントIDを受け取る変数
    var documenteId = ""
    
    //選択された部屋で投稿されたメッセージを全件もつ配列
    //プロパティを設けた･･･書き換わると実行される書式
    var  messages: [Message] = [] {
        //変数messageの値が変わったときに実行される
        didSet {
            //テーブルを更新
            tableView.reloadData()
    
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Forestoreに摂津族
        let db = Firestore.firestore()
        
        //選ばれた部屋の中のメッセージを感知
        db.collection("room").document(documenteId).collection("message").addSnapshotListener { (querySnapshot, Error) in
//                print("送信されました")
            
            //querySnapShotがもっているドキュメントを取得
            guard let documents =  querySnapshot?.documents else {
                //取得したドキュメントが空の場合処理を中断
                return
            }
            
            //変数documentsに全データがあるので、
            //それを元に配列を作成し、画面を更新する
            var messages: [Message] = []
            
            for document in documents {
                let documentId = document.documentID
                let text = document.get("text") as! String
                
                let message = Message(documentId: documentId, text: text)
                messages.append(message)
            }
            
            //変数roomsを書き換える
            self.messages = messages
            
            //取得したドキュメントが空の場合処理を中断
            
            //取得したドキュメントを元に、画面を更新
            
        }
    }
    

    @IBAction func didClickButton(_ sender: UIButton) {
        
        //　文字が空がどうか
        if messageTextField.text!.isEmpty {
            //からの場合は処理中断
            return
        }
        
        //登録処理について
        //画面に入力されたテキスト変数に保存
        let message = messageTextField.text!
        
        //firestoreに接続
        let db = Firestore.firestore()
        
        //メッセージをFirestoreに登録(選ばれた（まえの画面からSenderでdocumenteIdが送られている
        db.collection("room").document(documenteId).collection("message").addDocument(data: [
            "text": message,
            "createdAt":FieldValue.serverTimestamp()
        ]) { error in
            
            if let err = error {
                print("メッセージの送信に失敗しました")
                print(err)
            } else {
                print("メッセージを送信されました")
            }
        }
        //メッセージの入力欄のを空にする
        messageTextField.text = ""
    }
    


}

extension RoomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //テーブルviewに表示するデータの件数
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //セルの表示をする
        //セルの取得（セルの名前と、行番号から）
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //取得したセルにメッセージのテキストを設定
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        
        //できたセルを画面に返却
        return cell
        
        
        
    }
    
    
}


