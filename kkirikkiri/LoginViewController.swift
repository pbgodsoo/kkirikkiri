//
//  LoginViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 11/29/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var signupLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UITapGestureRecognizer 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //비밀번호 보안 텍스트
        passwordTextField.isSecureTextEntry = true
        
        
        //끼리끼리 폰트
        titleLabel.font = UIFont(name: "BMHANNAProOTF", size: 58)
        
        //textField 모서리 조정
        ///emailTextField.layer.borderWidth = 0 // 테두리 두께
        ///emailTextField.layer.borderColor = UIColor.red.cgColor // 테두리 색상
        emailTextField.layer.cornerRadius = 12.0 // 모서리 둥글기
        passwordTextField.layer.cornerRadius = 12.0 // 모서리 둥글기
        
        
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: emailTextField.frame.height))
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = .always
        
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: passwordTextField.frame.height))
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = .always
        
        // 회원가입 화면으로 이동
        // UITapGestureRecognizer 추가
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSignUpLabel))
//        signupLabel.isUserInteractionEnabled = true // 상호작용 활성화
//        signupLabel.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "모든 필드를 입력해주세요.")
            return
        }
        
        // Firebase로 로그인 요청
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.showAlert(message: "로그인 실패: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                if user.isEmailVerified {
                    print("User successfully signed in and email is verified: \(user.uid)")
                    self.showAlert(message: "로그인 성공!") {
                        // 이메일 인증 완료 후 화면 전환
                        self.navigateToHomeScreen()
                    }
                } else {
                    print("User signed in but email is not verified.")
                    self.showAlert(message: "이메일 인증이 필요합니다. 이메일을 확인하고 인증을 완료해주세요.")
                    try? Auth.auth().signOut() // 인증되지 않은 사용자 로그아웃 처리
                }
            }
        }
    }
    
    @IBAction func didTapForgotPassword(_ sender: Any) {
        // AlertController로 작은 창 띄우기
        let alert = UIAlertController(title: "비밀번호 재설정", message: "이메일 주소를 입력하면 비밀번호 재설정 링크를 보내드립니다.", preferredStyle: .alert)
        
        // 텍스트 필드 추가
        alert.addTextField { textField in
            textField.placeholder = "이메일 주소를 입력하세요."
            textField.keyboardType = .emailAddress
        }
        
        // "보내기" 버튼
        let sendAction = UIAlertAction(title: "보내기", style: .default) { _ in
            // 텍스트 필드에서 이메일 가져오기
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                self.showAlert(message: "이메일 주소를 입력해주세요.")
                return
            }
            
            // Firebase를 통해 비밀번호 재설정 이메일 전송
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print("Error sending password reset email: \(error.localizedDescription)")
                    self.showAlert(message: "이메일 전송 실패: \(error.localizedDescription)")
                } else {
                    print("Password reset email sent successfully.")
                    self.showAlert(message: "비밀번호 재설정 링크가 이메일로 전송되었습니다.")
                }
            }
        }
        
        // "취소" 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        // AlertController에 액션 추가
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        
        // AlertController 표시
        present(alert, animated: true, completion: nil)
    }
    // UIAlertController로 사용자에게 메시지 표시
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        self.present(alert, animated: true, completion: nil)
    }

    // 로그인 후 홈 화면 이동
    // Root View Controller 변경 메서드
    private func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Main 스토리보드 이름 사용
        guard let homeVC = storyboard.instantiateViewController(withIdentifier: "BaseTabBar") as? BaseTabBarController else {
            print("BaseTabBarController를 찾을 수 없습니다.")
            return
        }

        // Root View Controller 변경
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = homeVC // Root View Controller 바로 설정
            window.makeKeyAndVisible() // 화면 업데이트on: nil)
        }
    }
    
    // 회원가입 화면 이동
    @IBAction func didTapSignUpLabel(_ sender: Any) {
        // 스토리보드 파일 로드
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController else {
            print("회원가입 화면을 찾을 수 없습니다.")
            return
        }

        // 화면 전환 (Modal 방식)
        signUpVC.modalPresentationStyle = .fullScreen // 전체 화면으로 표시
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    // 키보드를 숨기는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}




