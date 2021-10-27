//
//  InputViewController.swift
//  taskapp
//
//  Created by book mac on 2021/10/22.
//

import UIKit
import RealmSwift
import UserNotifications //レッスン６　チャプター７.３　ローカル通知で追加

class InputViewController: UIViewController {
    

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //課題で追加
    @IBOutlet weak var category: UITextField!
    
    let realm = try! Realm()    // 追加する
    var task: Task!   // 追加する
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
       
        //課題で追加
        category.text = task.category
        
        
        // Do any additional setup after loading the view.
    }
    
    // 追加する
    //遷移するとき、画面が非表示になるときに呼ばれるメソッド
    //↑この意味は、タスクの入力画面から、タスク一覧の画面に切り替わる瞬間は「タスクの入力画面」は非表示になる。
    //その瞬間にされる処理
    
        override func viewWillDisappear(_ animated: Bool) {
            try! realm.write {
                
                //データベースにtitleTextFieldなどに入力した値を入れる
                self.task.title = self.titleTextField.text!
                self.task.contents = self.contentsTextView.text
                self.task.date = self.datePicker.date
                
                //課題で追加
                self.task.category = self.category.text!
                
                //realmが本体。本体のデータベースに値を入れる
                self.realm.add(self.task, update: .modified)
                
                
                
            }

            setNotification(task: task)   // 追加
            super.viewWillDisappear(animated)
        }
    
    //レッスン６　チャプター７.３ローカル通知で追加
    
    // タスクのローカル通知を登録する --- ここから ---
        func setNotification(task: Task) {
            let content = UNMutableNotificationContent()
            // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
            if task.title == "" {
                content.title = "(タイトルなし)"
            } else {
                content.title = task.title
            }
            if task.contents == "" {
                content.body = "(内容なし)"
            } else {
                content.body = task.contents
            }
            content.sound = UNNotificationSound.default
            
           

            // ローカル通知が発動するtrigger（日付マッチ）を作成
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
            let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)

            // ローカル通知を登録
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
            }

            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
            }
        } // --- ここまで追加 ---
    
    
    
    
    @objc func dismissKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
