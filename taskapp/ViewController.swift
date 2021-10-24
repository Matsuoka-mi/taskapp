//
//  ViewController.swift
//  taskapp
//
//  Created by book mac on 2021/10/19.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self       //tableViewはself(ViewController)に表示データと挙動を委譲
        tableView.dataSource = self
        
    }
    
    //データの数（＝セルの数）を返すメソッド
    //lesson3 chapter6.1 [func total(first a:Int)...total(first:50)で　aに50を代入]
    //func total(_ a:Int)...total(50) でaに50を代入
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return 0   //0個のデータがあるという意味
        
    }

    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        //再利用可能なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    //各セルを選択したときに実行されるメソッド
    //didSelectRowAtはUITableViewDelegateプロトコルのメソッドでセルをタップしたときにタスク入力画面に遷移させる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)  //追加する
    }
    
    //セルが削除可能なことを伝えるメソッド
    //editingStyleForRowAtはUITableViewDelegateプロトコルのメソッドで、セルが削除可能か、並び替えが可能かなどどのような編集ができるかを返す（このプロジェクトでは.delete を返している削除可能なことを伝える）
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
        
    }
    //Deletボタンが押されたときに呼ばれるメソッド
    //commit:forRowAtはUITableView DataSourceプロトコルのメソッドで、Deleteボタンが押されたときにローカル通知をキャンセルし、データベースからタスクを削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        
    }
    
    

}

