//
//  LoginController.swift
//  modooagit
//
//  Created by lee on 2022/02/19.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class LoginViewController: UIViewController{
    var remoteConfig: RemoteConfig?
    

    @IBOutlet var emailLoginButton: UIButton!
    @IBOutlet var appleLoginButton: UIButton!
    @IBOutlet var googleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remoteConfig = RemoteConfig.remoteConfig()
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig?.configSettings = setting
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        [emailLoginButton,appleLoginButton,googleLoginButton].forEach{
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotice()
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func appleLoginButtonTappeed(_ sender: UIButton) {
        
    }
    
}
extension LoginViewController{
    func getNotice(){
        guard let remoteConfig = remoteConfig else {return}
        
        remoteConfig.fetch { [weak self] status, _ in
            if status == .success{
                remoteConfig.activate(completion: nil)
            }else{
                print("error: config not fetched")
            }
            guard let self = self else {return}
            
            if !self.isNoticeHidden(remoteConfig){
                let noticeVC = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                noticeVC.modalPresentationStyle = .custom
                noticeVC.modalTransitionStyle = .crossDissolve
                
                let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let date = (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                noticeVC.noticeContents = (title: title, detail: detail, date: date)
                self.present(noticeVC, animated: true,completion: nil)
            }else{
                //이벤트 얼럿 띄우기
                //self.showEventAlert()
            }
        }
        
    }
    func isNoticeHidden(_ remoteConfig:RemoteConfig)->Bool{
        return remoteConfig["isHidden"].boolValue
    }
}

extension LoginViewController {
    func showEventAlert(){
        guard let remoteConfig = remoteConfig else {return}
        remoteConfig.fetch { [weak self] status, _ in
            if status == .success{
                remoteConfig.activate(completion: nil)
            }else{
                print("not fetch")
            }
            let message = remoteConfig["message"].stringValue ?? ""
            
            let confirmAction = UIAlertAction(title: "확인하기",style: .default){ _ in
                Analytics.logEvent("promotion_alert", parameters: nil)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let alertController = UIAlertController(title: "이벤트 테스트", message: message, preferredStyle: .alert)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self?.present(alertController, animated: true, completion: nil)
        }
        
    }
}
