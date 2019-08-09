//
//  ViewController.swift
//  SimpleChatApp
//
//  Created by 堀川浩二 on 2019/08/08.
//  Copyright © 2019 堀川浩二. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var roomNamaTextField: UITextField!
    
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
        
    }

    //ルーム作成のボタンがクリックされたとき
    @IBAction func didClickButton(_ sender: UIButton) {
        
        //空文字だったら
        if roomNameTextField.text?.isEmpty {
            //テキストfieldが空文字の場合
            //処理中断
            return
        }
        
        //部屋の名前を変数に保存
        let roomNeme = roomNamaTextField.text!
        
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
    }
    
    
}


