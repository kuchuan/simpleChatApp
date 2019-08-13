//
//  RoomViewController.swift
//  SimpleChatApp
//
//  Created by 堀川浩二 on 2019/08/09.
//  Copyright © 2019 堀川浩二. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    //どの部屋かを特定するためのドキュメントIDを受け取る変数
    var documenteId = ""
    
    //選択された部屋で投稿されたメッセージを全件もつ配列
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
    @IBAction func didClickButton(_ sender: UIButton) {
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


