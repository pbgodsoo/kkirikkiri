//
//  signupViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 11/29/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {
    // Firestore 인스턴스 초기화
    let db = Firestore.firestore()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordCheckTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var majorTextField: UITextField!
    @IBOutlet var schoolNumTextField: UITextField!
    @IBOutlet var birthTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UITapGestureRecognizer 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Title 설정
        titleLabel.font = UIFont(name: "BMHANNAProOTF", size: 44)
        
        //비밀번호 보안 텍스트
        passwordTextField.isSecureTextEntry = true
        passwordCheckTextField.isSecureTextEntry = true
        
        // Text Field 설정
        emailTextField.layer.cornerRadius = 12.0 // 모서리 둥글기
        passwordTextField.layer.cornerRadius = 12.0 // 모서리 둥글기
        passwordCheckTextField.layer.cornerRadius = 12.0
        nameTextField.layer.cornerRadius = 12.0
        majorTextField.layer.cornerRadius = 12.0
        schoolNumTextField.layer.cornerRadius = 12.0
        birthTextField.layer.cornerRadius = 12.0
        
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: emailTextField.frame.height))
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = .always

        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: passwordTextField.frame.height))
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = .always
        
        let passwordCheckPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: passwordCheckTextField.frame.height))
        passwordCheckTextField.leftView = passwordCheckPaddingView
        passwordCheckTextField.leftViewMode = .always
        
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
        nameTextField.leftView = namePaddingView
        nameTextField.leftViewMode = .always
        
        let majorPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: majorTextField.frame.height))
        majorTextField.leftView = majorPaddingView
        majorTextField.leftViewMode = .always
        
        let schoolNumPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: schoolNumTextField.frame.height))
        schoolNumTextField.leftView = schoolNumPaddingView
        schoolNumTextField.leftViewMode = .always
        
        let birthPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: birthTextField.frame.height))
        birthTextField.leftView = birthPaddingView
        birthTextField.leftViewMode = .always
        
    }
    
    // 회원가입 처리
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        // 이메일과 비밀번호 입력 확인
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let checkPassword = passwordCheckTextField.text, !checkPassword.isEmpty,
              let userName = nameTextField.text, !userName.isEmpty,
              let userMajor = majorTextField.text, !userMajor.isEmpty,
              let schoolNum = schoolNumTextField.text, !schoolNum.isEmpty,
              let birth = birthTextField.text, !birth.isEmpty else {
            showAlert(message: "모든 필드를 입력해주세요.")
            return
        }

        // 비밀번호 확인
        if password != checkPassword {
            showAlert(message: "비밀번호가 일치하지 않습니다.")
            return
        }

        // Firebase 회원가입 요청
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return } // weak self로 메모리 순환 참조 방지
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                self.showAlert(message: "회원가입 실패: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                print("User successfully created: \(user.uid)")

                // 이메일 인증 메일 보내기
                user.sendEmailVerification { error in
                    if let error = error {
                        print("Failed to send email verification: \(error.localizedDescription)")
                        self.showAlert(message: "회원가입 성공! 그러나 이메일 인증 메일 전송에 실패했습니다.")
                    } else {
                        print("Email verification sent.")
                        self.showAlert(message: "회원가입 성공! 이메일 인증을 완료해주세요.") {
                            // 회원가입 후 이메일 인증 안내 화면 또는 로그인 화면으로 이동
                            self.navigateToLogin()
                        }
                    }
                }
                
                // Firestore에 사용자 정보 저장
                self.db.collection("users").document(user.uid).setData([
                    "email": email,
                    "name": userName,
                    "major": userMajor,
                    "schoolNum": schoolNum,
                    "birth": birth,
                    "created_at": Timestamp(date: Date()) // 계정 생성 시간 추가
                ]) { error in
                    if let error = error {
                        print("Error saving user to Firestore: \(error.localizedDescription)")
                        self.showAlert(message: "회원가입 성공! 그러나 사용자 정보 저장에 실패했습니다.")
                    } else {
                        print("User information saved to Firestore.")
                        self.showAlert(message: "회원가입 성공! 로그인 화면으로 이동합니다.") {
                            // 화면 전환 또는 추가 작업
                            self.navigateToLogin()
                        }
                    }
                }
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        // 이전 화면으로 이동
        self.dismiss(animated: true, completion: nil)
    }
    
    // UIAlertController로 사용자에게 메시지 표시
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        self.present(alert, animated: true, completion: nil)
    }

    // 회원가입 완료 후 로그인 화면으로 이동
    func navigateToLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 키보드를 숨기는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
