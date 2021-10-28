//
//  Task.swift
//  taskapp
//
//  Created by book mac on 2021/10/24.
//

import RealmSwift

class Task: Object {
    //管理用ID プライマリーキー
    @objc dynamic var id = 0
    
    //タイトル
    @objc dynamic var title = ""
    
    //内容
    @objc dynamic var contents = ""
    
    //日時
    @objc dynamic var date = Date()
    
    //カテゴリ
    //課題
    @objc dynamic var category:String = ""
    
    //idをプライマリーキーとして設定
    override static func primaryKey() -> String{
        return "id"
    }
    
}
