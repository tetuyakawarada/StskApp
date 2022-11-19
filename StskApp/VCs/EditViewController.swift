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
    let consts = Constants.shared
//    let okAlert = OkAlert()
    
    @IBOutlet weak var finishPageTextField: UITextField! //①


    override func viewDidLoad() {
        super.viewDidLoad()
        //token読み込み
        token = LoadToken().loadAccessToken()
    }
    
    @IBAction func updateButton(_ sender: Any) {
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
