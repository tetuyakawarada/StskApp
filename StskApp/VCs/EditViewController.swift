//
//  EditViewController.swift
//  StskApp
//
//  Created by tetsuya on 2022/11/17.
//

import UIKit
import Alamofire
import KeychainAccess
import Kingfisher


class EditViewController: UIViewController {
    var taskId: Int!
    private var token = ""
    private var task: UpdatingTask!
    var taskID = ""
    let consts = Constants.shared
//    let okAlert = OkAlert()
    
    @IBOutlet weak var finishPageTextField: UITextField! //①

    
//    @IBOutlet weak var test: UILabel!
//
//    @IBAction func testtest(_ sender: UIStepper) {
//        test.text = "値：\(sender.value)"
//    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //token読み込み
        token = LoadToken().loadAccessToken()
        //記事のIDがnilじゃなければ記事を読み込む
        guard let id = taskId else { return }
        loadTask(taskId: id)

    }
    
    //編集したい記事の情報をapiでリクエストして読み込む
    func loadTask(taskId: Int) {
        guard let url = URL(string: consts.baseUrl + "/api/tasks/\(taskId)") else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request(
            url,
            headers: headers
        ).responseDecodable(of: Task.self) { response in
            switch response.result {
            case .success(let task):
                self.finishPageTextField.text = "\(task.finishPage)"
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //---------------------------------
    

//    func updateRequest(task: Updatingtask) {
//        let url = URL(string: consts.baseUrl + "/api/tasks/"+taskID)!
//        let parameters: Parameters = [
//            "body": task.body,
//            "title": task.title
//        ]
//        let headers :HTTPHeaders = [.authorization(bearerToken: token)]
//        AF.request(url,
//            method: .patch,
//            parameters: parameters,
//            encoding: JSONEncoding.default,
//            headers: headers
//        ).response { response in
//            switch response.result {
//            case .success:
//                self.okAlert.showOkAlert(title: "更新しました", message: "記事の更新をしました", viewController: self)
//            case .failure(let err):
//                self.okAlert.showOkAlert(title: "エラー", message: err.localizedDescription, viewController: self)
//                print(err.localizedDescription)
//            }
//        }
//    }
//
//    //cratePostingArticleとほぼほぼ一緒(型が変わっただけ)
//    func createUpdatingArticle() -> UpdatingArticle {
//        if titleField.text == "" || bodyTextView.text == "" {
//            okAlert.showOkAlert(title: "空欄があります", message: "全ての欄に入力をしてください。", viewController: self)
//        }
//        let article = UpdatingArticle(title: titleField.text!, body: bodyTextView.text!)
//        return article
//    }
    
    
    
    
    //---------------------------------
    //更新のリクエスト→ボツ
    func updateRequest(token: String, taskId: Int) {
        
        //URLに記事のIDを含めることを忘れずに!
        guard let url = URL(string: consts.baseUrl + "/api/tasks/\(taskId)") else { return }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json"),
            .contentType("multipart/form-data")
        ]
        
        //文字情報と画像やファイルを送信するときは 「AF.upload(multipartFormData: …」 を使う
        AF.upload(
            multipartFormData: { multipartFormData in
                
                guard let finishPageTextData = self.finishPageTextField.text?.data(using: .utf8) else {return}
                multipartFormData.append(finishPageTextData, withName: "finishPage")
                
                print("-----")
                print(finishPageTextData)
                print(self.finishPageTextField.text!)
                print("-----")
                
                //「PATCH」のHTTPメソッドをmultipartFormDataに追加
                guard let method = "patch".data(using: .utf8) else { return }
                multipartFormData.append(method, withName: "_method")
            },
            to: url,
            method: .post,
            headers: headers
        ).response { response in
            switch response.result {
            case .success:
                self.completionAlart(title: "更新完了!", message: "記事を更新しました")
            case .failure(let err):
                print("-----")
                print(err)
                print("-----")
//                self.okAlert.showOkAlert(title: "エラー!", message: "\(err)", viewController: self)
            }
        }
    }
    //---------------------------------

    
    //更新または削除処理完了の際に表示するアラート。OKを押すと、前の画面に戻る
    func completionAlart(title: String, message: String) {
        let alert = UIAlertController(title: title , message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }



    
    @IBAction func updateButton(_ sender: Any) {
        self.updateRequest(token: token, taskId: taskId)
    }

    @IBAction func deleteButton(_ sender: Any) {
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

extension UITextField {
    var textToInt: Int {
        let text = self.text
        let int = text
            .flatMap{Int($0)} ?? 0
        return int
    }
}

