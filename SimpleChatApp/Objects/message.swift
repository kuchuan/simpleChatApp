//
//  Message.swift
//  SimpleChatApp
//
//  Created by 堀川浩二 on 2019/08/09.
//  Copyright © 2019 堀川浩二. All rights reserved.
//

import Foundation

struct Message {
    
    //メッセージのID(Firestoreで使用するキー）
    let documentId: String
    
    //送信されたメッセージ
    let text: String
}
