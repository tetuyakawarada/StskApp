//
//  LoginViewController.swift
//  StskApp
//
//  Created by tetsuya on 2022/11/14.
//

import UIKit
import AuthenticationServices
import Alamofire
import KeychainAccess

class LoginViewController: UIViewController {
    let consts = Constants.shared  //Constantsに格納しておいた定数を使うための用意
    var session: ASWebAuthenticationSession? //Webの認証セッションを入れておく変数
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let keychain = Keychain(service: consts.service)
        //if keychain["access_token"] != nil {
        //    keychain["access_token"] = nil //keychainに保存されたtokenを削除
        //}
    }
    
    //取得したcodeを使ってアクセストークンを発行
    func getAccessToken(code: String) {
        //オプショナルバインディングでアンラップ
        guard let url = URL(string: consts.baseUrl + "/oauth/token") else { return }
        
        //トークン発行に必要なパラメータを追加していく。
        let parameters: Parameters = [
            "grant_type": "authorization_code",
            "client_id": consts.clientId,
            "client_secret": consts.clientSecret,
            "code": code,
        ]
        
        //Alamofireでリクエスト
        AF.request(
            url,
            method: .post,
            parameters: parameters
        ).responseDecodable(of: GetToken.self) { response in
            switch response.result {
            case .success(let value):
                let token = value.accessToken
                print("TOKEN:", token)
                let keychain = Keychain(service: self.consts.service) //このアプリ用のキーチェーンを生成
                keychain["access_token"] = token //トークンをキーチェーンに保存
                self.transitionToIndex() //NavigationController経由で一覧画面へ
            case .failure(let err):
                print(err)
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let keychain = Keychain(service: consts.service)
        if keychain["access_token"] != nil { //アクセストークンが既に取得できているときの処理
            //アクセストークンが既に取得できているときの処理
            transitionToIndex()
        } else {
            //オプショナルバインディングでURLをアンラップ
            guard let url = URL(string: consts.oauthUrl + "?client_id=\(consts.clientId)&response_type=code&scope=") else { return }
            session = ASWebAuthenticationSession(url: url, callbackURLScheme: consts.callbackUrlScheme) {(callback, error) in
                guard error == nil, let successURL = callback else { return }
                let queryItems = URLComponents(string: successURL.absoluteString)?.queryItems
                guard let code = queryItems?.filter({ $0.name == "code" }).first?.value else { return }
                print("CODE:", code)
                self.getAccessToken(code: code) //取得したcodeでアクセストークンをリクエスト
            }
        }
        session?.presentationContextProvider = self //デリゲートを設定
        session?.prefersEphemeralWebBrowserSession = true //認証セッションと通常のブラウザで閲覧情報やCookieを共有しないように設定。
        session?.start()  //セッションの開始(これがないと認証できない)
    }
    
    func transitionToIndex() {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

//ログインボタンを押したときに認証の画面に遷移できる
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}

