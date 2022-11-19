//
//  DetailViewController.swift
//  StskApp
//
//  Created by tetsuya on 2022/11/17.
//

import UIKit
import Alamofire
import KeychainAccess

class DetailViewController: UIViewController {
    var taskId: Int! //Indexの画面から受け取る
    var myUser: User!   //Indexの画面から受け取る
    
    let consts = Constants.shared
    private var token = ""
    
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var totalPageLabel: UILabel!
    @IBOutlet weak var pageTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!

    
    @IBOutlet weak var finishPageLabel: UILabel!
    @IBOutlet weak var pageTimeLabel2: UILabel!
    @IBOutlet weak var progressTimeLabel: UILabel!
    
    
    @IBOutlet weak var degreeTimeLabel: UILabel!

    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!

    @IBOutlet weak var editAndDeleteButtonState: UIBarButtonItem!

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        editAndDeleteButtonState.isEnabled = false
//        editAndDeleteButtonState.tintColor = UIColor.clear
        token = LoadToken().loadAccessToken() //トークン読み込み


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //IDが渡ってきているかをチェックしてから実行
        if let id = taskId {
            getTasks(id: id)
        }
    }
    
    //idから記事と一緒にコメントを取得
    func getTasks(id: Int) {
        guard let url = URL(string: consts.baseUrl + "/api/tasks/\(id)") else { return }
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(
            url,
            headers: headers
        ).responseDecodable(of: Task.self) { response in
            switch response.result {
            case .success(let task):
                print("🌟success from Detail🌟")

                //それぞれのラベルやイメージビューに受け取ったものを入れる
                self.subjectNameLabel.text = task.subjectName
                self.titleLabel.text = task.title
                self.bodyLabel.text = task.body

                self.totalPageLabel.text = "所要時間：" + "\(task.totalPage)"+" p ×"
                self.pageTimeLabel.text = "\(task.pageTime)"+" 分 ="
                self.totalTimeLabel.text = "\(task.totalTime)"+" 分"

                
                self.finishPageLabel.text = "経過時間：" + "\(task.finishPage)"+" p ×"
                self.pageTimeLabel2.text = "\(task.pageTime)"+" 分 ="
                self.progressTimeLabel.text = "\(task.progressTime)"+" 分"
                
                self.createdAtLabel.text = "作成日時：" + task.createdAt
                self.updatedAtLabel.text = "更新日時：" + task.updatedAt

                self.degreeTimeLabel.text = "\(task.degreeTime)"



//                @IBOutlet weak var createdAtLabel: UILabel!
//                @IBOutlet weak var updatedAtLabel: UILabel!

//                self.authorLabel.text = article.userName
//                self.createdAtLabel.text = article.createdAt
//                self.bodyLabel.text = article.body
//                self.articleImageView.kf.setImage(with: URL(string: article.imageUrl)!)

                //コメントがあったら定義しておいた変数に入れる
//                guard let comments = article.comments else { return }
//                self.comments = comments
//                self.commentTableView.reloadData()

                //投稿者と自分のnameが一致したとき…
                if let user = self.myUser {
                    if user.name == task.userName {
                        //編集削除のボタンを見えるようにして押せる状態にする
                        self.editAndDeleteButtonState.isEnabled = true
                        self.editAndDeleteButtonState.tintColor = UIColor.systemBlue
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func editOrDeleteButton(_ sender: Any) {
        guard let taskId = taskId else { return }
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "Edit") as! EditViewController
        editVC.taskId = taskId
        navigationController?.pushViewController(editVC, animated: true)
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


