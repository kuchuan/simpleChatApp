//
//  ViewController.swift
//  SimpleChatApp
//
//  Created by 堀川浩二 on 2019/08/08.
//  Copyright © 2019 堀川浩二. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var roomNameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    //チャットのへ部屋一覧を保持する配列
    var rooms: [Room] = [] {
        // roomsが活気変わる
        didSet {
            //テーブルを更新する
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate  = self
        
        //firestoreへの接続
        let db = Firestore.firestore()
        
        
        //コレクションroomが変更されたかどうかのを検知するリスナーを登録する
        db.collection("room").addSnapshotListener { (querySnapshot, error) in
            
            //querySnapshot.documents:room内の全件を取得
            guard let documents = querySnapshot?.documents else {
                    //roomの中に何もないとき、処理を中断
                    return
            }
            
            
            //変数documentsにroomの全データがあるので、
            //それを元に配列を作成し、画面を更新する
            var results: [Room] = []
            
            for document in documents {
                let roomName = document.get("name") as! String
                let room = Room(name: roomName, documentId: document.documentID)
                
                results.append(room)
            }
            
            //変数roomsを書き換える
            self.rooms = results
        }
        
        
    }

    //ルーム作成のボタンがクリックされたとき
    @IBAction func didClickButton(_ sender: UIButton) {
        if roomNameTextField.text!.isEmpty {
            // テキストフィールドが空文字の場合
            // 処理中断
            return
        }
        
        // 部屋の名前を変数に保存
        let roomName = roomNameTextField.text!
        
        // Firestoreの接続情報取得
        let db = Firestore.firestore()
        
        // Firestoreに新しい部屋を追加（roomがないと自動で作ってくれる！便利！）
        db.collection("room").addDocument(data: [
            "name": roomName,
            "createdAt": FieldValue.serverTimestamp()
        ]) { err in
            
            if let err = err {
                print("チャットルームの作成に失敗しました")
                print(err)
            } else {
                print("チャットルームを作成しました：\(roomName)")
            }
        }
        
        roomNameTextField.text = ""
    }
}

        


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.name
        
        //右矢印
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    //didSelectRowAtはセルがクリックされたら
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let room = rooms[indexPath.row]
        
        // 選択を解除（グレーの色を元に戻す）
        tableView.deselectRow(at: indexPath, animated: true)
        
        //つぎの画面へ遷移する
        performSegue(withIdentifier: "toRoom", sender: room.documentId)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //間違った画面に値を渡さないようにsegue.identifier
        if segue.identifier == "toRoom" {
            
            let roomVC = segue.destination as! RoomViewController
            roomVC.documenteId = sender as! String
            
        }
    }
    
}


