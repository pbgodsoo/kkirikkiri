//
//  MyPageViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/6/24.
//

import UIKit
import FirebaseAuth

class MyPageViewController: UIViewController {
    
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var majorTextField: UITextField!
    @IBOutlet var studentIDTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UITapGestureRecognizer 추가
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tapGesture)
    
        // 내 사진 원형으로 만들기
        myImageView.layer.cornerRadius = myImageView.frame.size.width / 2
        myImageView.clipsToBounds = true
        
        // 컨테이너 뷰 조정
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        
    }

    @IBAction func handleTapActivity(_ sender: UITapGestureRecognizer) {
        print("내 활동 버튼이 눌렸습니다.")
        // 필요한 동작 추가
        // 스토리보드에서 MyActivityViewController 인스턴스 가져오기
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myActivityVC = storyboard.instantiateViewController(withIdentifier: "MyActivityViewController")
        myActivityVC.modalPresentationStyle = .fullScreen
        present(myActivityVC, animated: false, completion: nil) // 애니메이션 없이 전환
    
    }

    @IBAction func handleTapTeamEvaluation(_ sender: UITapGestureRecognizer) {
        print("팀원 평가 버튼이 눌렸습니다.")
        // 필요한 동작 추가
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myActivityVC = storyboard.instantiateViewController(withIdentifier: "TeamEvaluationViewController")
        myActivityVC.modalPresentationStyle = .fullScreen
        present(myActivityVC, animated: false, completion: nil) // 애니메이션 없이 전환
    }

    @IBAction func handleTapMyEvaluation(_ sender: UITapGestureRecognizer) {
        print("나의 평가 버튼이 눌렸습니다.")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myActivityVC = storyboard.instantiateViewController(withIdentifier: "ReviewViewController")
        myActivityVC.modalPresentationStyle = .fullScreen
        present(myActivityVC, animated: false, completion: nil) // 애니메이션 없이 전환
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            emailTextField.isUserInteractionEnabled = true
            emailTextField.becomeFirstResponder()
        // Save the updated text after editing
        case 1:
            majorTextField.isUserInteractionEnabled = true
            majorTextField.becomeFirstResponder()
        case 2:
            studentIDTextField.isUserInteractionEnabled = true
            studentIDTextField.becomeFirstResponder()
        case 3:
            birthTextField.isUserInteractionEnabled = true
            birthTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
    // Tap Gesture가 호출되면 실행되는 함수
    @IBAction func didTapLogoutLabel(_ sender: Any) {
        do {
            // Firebase 로그아웃
            try Auth.auth().signOut()
            print("User successfully logged out")
            
            // Root View Controller를 로그인 화면으로 변경
            navigateToLoginScreen()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
            showAlert(message: "로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    // 로그인 화면으로 이동하는 함수
   func navigateToLoginScreen() {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
       loginVC.modalPresentationStyle = .fullScreen
       present(loginVC, animated: true, completion: nil)
   }
   
   // 오류 메시지를 표시하는 함수
   func showAlert(message: String) {
       let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
       present(alert, animated: true, completion: nil)
   }
    // 키보드를 숨기는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

