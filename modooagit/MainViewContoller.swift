//
//  MainViewContoller.swift
//  modooagit
//
//  Created by lee on 2022/02/19.
//

import UIKit
import Firebase

class MainViewController:UIViewController{
    
    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
      super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다
        \(email)님
        """
    }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
