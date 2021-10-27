//
//  ViewController.swift
//  taskapp
//
//  Created by book mac on 2021/10/19.
//

import UIKit
import RealmSwift  //追加
import UserNotifications    // chapter 7.4 タスク削除の時　通知をキャンセル

//課題でsearchBarを入れたので、UISearchBarDelegateを追記した。
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    @IBOutlet weak var tableView: UITableView!
    

    //課題で追加 SearchBar をつなげた
    
    @IBOutlet weak var kensaku: UISearchBar!
    
    
    //Realmインスタンスを取得する
    let realm = try! Realm() //追加　エラーがあっても無視する
    
    
    //DB内のタスクが格納されるリスト
    //日付の近い順でソート：昇順
    //以降内容をアップデートするとリスト内は自動的に更新される。
    
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true) //追加
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self       //tableViewはself(ViewController)に表示データと挙動を委譲
        tableView.dataSource = self
        
        //課題で追加　　一番上にUISearchBarDelegate　を追記した。使えるようにするため。
        //kensakuはself(ViewController)に 委譲
        kensaku.delegate = self
        print(taskArray)
       
    }
    
    
    //データの数（＝セルの数）を返すメソッド
    //lesson3 chapter6.1 [func total(first a:Int)...total(first:50)で　aに50を代入]
    //func total(_ a:Int)...total(50) でaに50を代入
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return taskArray.count   //return 0 なら0個のデータがあるという意味
        //データの配列であるtaskArrayの要素数を返している。
        
    }

    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        //再利用可能なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        //chapter6.7で追記
        //Cellに値を設定する
        
     
        let task = taskArray[indexPath.row]
                
        
        cell.textLabel?.text = task.title
     
       
        //課題で追加して試した。　カテゴリに入力した値がタイトルの場所に表示された
        //     cell.textLabel?.text = task.category
        
        
        //DateFormatterクラスは日付を表すDateクラスを任意の形の文字列に変換する機能を持つ
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        //ここまで追記
        
        return cell
    }
    
    
    //各セルを選択したときに実行されるメソッド
    //didSelectRowAtはUITableViewDelegateプロトコルのメソッドでセルをタップしたときにタスク入力画面に遷移させる
    //ViewControllerのセルをタップしたときに呼ばれるtableView(_:didSelectRowAt:)メソッドへsegueのIDを指定して遷移させるperformSegue(withIdentifier:sender)メソッドの呼び出しを追加する
    //→タップしたら呼ばれるメソッドがあるので、それに、Segue IDを指定できるメソッドを追加する
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
        
        //chapter6.7で追記
   //    if editingStyle == .delete {
                    // データベースから削除する
  //                  try! realm.write {
  //                      self.realm.delete(self.taskArray[indexPath.row])
  //                      tableView.deleteRows(at: [indexPath], with: .fade)
  //                  }
  //              } // --- ここまで追加 ---
        
        // --- ここから ---
                if editingStyle == .delete {
                    // 削除するタスクを取得する
                    let task = self.taskArray[indexPath.row]

                    // ローカル通知をキャンセルする
                    let center = UNUserNotificationCenter.current()
                    center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])

                    // データベースから削除する
                    try! realm.write {
                        self.realm.delete(task)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }

                    // 未通知のローカル通知一覧をログ出力
                    center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                        for request in requests {
                            print("/---------------")
                            print(request)
                            print("---------------/")
                        }
                    }
                } // --- ここまで変更 ---
    
    
    }

    
            // segue で画面遷移する時に呼ばれる
       override func prepare(for segue: UIStoryboardSegue, sender: Any?){
           let inputViewController:InputViewController = segue.destination as! InputViewController
        

           if segue.identifier == "cellSegue" {
               let indexPath = self.tableView.indexPathForSelectedRow
               inputViewController.task = taskArray[indexPath!.row]
           } else {
               let task = Task()

               let allTasks = realm.objects(Task.self)
               if allTasks.count != 0 {
                   task.id = allTasks.max(ofProperty: "id")! + 1
               }

               inputViewController.task = task
           }
        
       }
   

    // 入力画面から戻ってきた時に TableView を更新させる
    
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           tableView.reloadData()
       }
    
    //SearchBarに文字入力後、自動的に呼ばれる
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            taskArray = realm.objects(Task.self).sorted(byKeyPath: "date", ascending: true)
            tableView.reloadData()
        }
        else {
            taskArray = realm.objects(Task.self).filter("category = %@",searchText).sorted(byKeyPath: "date", ascending: true)
            tableView.reloadData()
            
          
        }
      
    }
    
 
}





