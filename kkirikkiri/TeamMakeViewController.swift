//
//  TeamMakeViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/8/24.
//

import UIKit
import FirebaseFirestore

class TeamMakeViewController: UIViewController, UITextViewDelegate {
    
    // Firestore 참조
    let db = Firestore.firestore()
    
    @IBOutlet var teamNameTextField: UITextField!
    @IBOutlet var checkBoxView: UIView!
    @IBOutlet var checkBoxButton1: UIButton! // 공모전
    @IBOutlet var checkBoxButton2: UIButton! // 비교과
    @IBOutlet var checkBoxButton3: UIButton! // 경진대회
    @IBOutlet var checkBoxButton4: UIButton! // 동아리
    @IBOutlet var checkBoxButton5: UIButton! // 소모임
    @IBOutlet var checkBoxButton6: UIButton! // 기타
    @IBOutlet var majorButton: UIButton!
    @IBOutlet var periodButton: UIButton!
    @IBOutlet var personalButton: UIButton!
    @IBOutlet var faceButton: UIButton!
    @IBOutlet var nonFaceButton: UIButton!
    @IBOutlet var textTextView: UITextView!
    @IBOutlet var activityNameTextField: UITextField!
    
    // 버튼 색상 정의
    let activeColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0) // 첫 번째 색 (녹색)
    let inactiveColor = UIColor(red: 0.94, green: 0.96, blue: 0.94, alpha: 1.0) // 두 번째 색 (연한 회색)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UITapGestureRecognizer 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //팀 이름 textField
        teamNameTextField.layer.cornerRadius = 12
        activityNameTextField.layer.cornerRadius = 12
        
        
        // UITextField의 왼쪽 뷰에 추가
        let teamNamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 20)) // teamNameTextField용 여백
        let activityNamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 20)) // activityNameTextField용 여백

        teamNameTextField.leftView = teamNamePaddingView
        teamNameTextField.leftViewMode = .always

        activityNameTextField.leftView = activityNamePaddingView
        activityNameTextField.leftViewMode = .always
        
        // 체크박스 뷰
        checkBoxView.layer.cornerRadius = 10
        checkBoxView.layer.borderWidth = 1
        checkBoxView.layer.borderColor = UIColor(red: 227/255, green: 246/255, blue: 206/255, alpha: 1.0).cgColor
        checkBoxView.clipsToBounds = true
        
        // 체크박스
        checkBoxButton1.setImage(UIImage(named: "checkBoxIcon"), for: .normal) // Normal 상태
        checkBoxButton1.setImage(UIImage(named: "checkBoxIcon2"), for: .selected) // Selected 상태
        checkBoxButton2.setImage(UIImage(named: "checkBoxIcon"), for: .normal) // Normal 상태
        checkBoxButton2.setImage(UIImage(named: "checkBoxIcon2"), for: .selected) // Selected 상태
        checkBoxButton3.setImage(UIImage(named: "checkBoxIcon"), for: .normal) // Normal 상태
        checkBoxButton3.setImage(UIImage(named: "checkBoxIcon2"), for: .selected) // Selected 상태
        checkBoxButton4.setImage(UIImage(named: "checkBoxIcon"), for: .normal) // Normal 상태
        checkBoxButton4.setImage(UIImage(named: "checkBoxIcon2"), for: .selected) // Selected 상태
        checkBoxButton5.setImage(UIImage(named: "checkBoxIcon"), for: .normal) // Normal 상태
        checkBoxButton5.setImage(UIImage(named: "checkBoxIcon2"), for: .selected) // Selected 상태
        checkBoxButton6.setImage(UIImage(named: "checkBoxIcon"), for: .normal) // Normal 상태
        checkBoxButton6.setImage(UIImage(named: "checkBoxIcon2"), for: .selected) // Selected 상태
        
        // 드롭다운 버튼
        majorButton.layer.cornerRadius = 12
        periodButton.layer.cornerRadius = 12
        personalButton.layer.cornerRadius = 12
        
        // 대면 버튼
        faceButton.layer.cornerRadius = 12
        nonFaceButton.layer.cornerRadius = 12
        updateButtonState(selectedButton: faceButton)
        
        textTextView.delegate = self // delegate 설정
        textTextView.font = UIFont.systemFont(ofSize: 16)
        textTextView.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 10, right: 10)
        //textTextView.layer.borderColor = UIColor.lightGray.cgColor
        //textTextView.layer.borderWidth = 1.0
        textTextView.layer.cornerRadius = 12

        // Placeholder처럼 초기 텍스트 설정
        textTextView.text = "원하는 팀의 조건을 입력하세요"
        textTextView.textColor = UIColor.lightGray
    }
    
    // 체크박스 상태 변경
    @IBAction func toggleCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle() // 선택 상태 변경
    }
    
    // 드롭다운
    @IBAction func majorTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "모집학과 선택", message: nil, preferredStyle: .actionSheet)
        let options = ["간호학과", "기계공학과", "컴퓨터공학과", "바이오의약학과", "스포츠건강학과","유아교육과","뷰티화장품학과","응용화학과", "생명공학과", "시각영상디자인학과", "녹색기술융합학과", "의예과", "식품영양학과", "경제통상학과"]
        
        for option in options {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { _ in
                sender.setTitle(option, for: .normal)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func periodTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "기간 선택", message: nil, preferredStyle: .actionSheet)
        let options = ["1주일", "2주일", "4주일", "8주일 이상"]
        
        for option in options {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { _ in
                sender.setTitle(option, for: .normal)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func personalTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "인원 선택", message: nil, preferredStyle: .actionSheet)
        let options = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
        
        for option in options {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { _ in
                sender.setTitle(option, for: .normal)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    // 대면 비대면
    @IBAction func faceTapped(_ sender: UIButton) {
        updateButtonState(selectedButton: sender)
    }
    
    @IBAction func nonFaceTapped(_ sender: UIButton) {
        updateButtonState(selectedButton: sender)
    }
    
    func updateButtonState(selectedButton: UIButton) {
        // face 버튼이 선택되었을 때
        if selectedButton == faceButton {
            faceButton.isEnabled = false // 비활성화
            faceButton.backgroundColor = activeColor // 활성화 색상
            faceButton.setTitleColor(UIColor.white, for: .normal)
            
            nonFaceButton.isEnabled = true // 활성화
            nonFaceButton.backgroundColor = inactiveColor // 비활성화 색상
            nonFaceButton.setTitleColor(UIColor.black, for: .normal)
        }
        // nonFace 버튼이 선택되었을 때
        else if selectedButton == nonFaceButton {
            nonFaceButton.isEnabled = false // 비활성화
            nonFaceButton.backgroundColor = activeColor // 활성화 색상
            nonFaceButton.setTitleColor(UIColor.white, for: .normal)
            
            faceButton.isEnabled = true // 활성화
            faceButton.backgroundColor = inactiveColor // 비활성화 색상
            faceButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    // UITextViewDelegate - 사용자가 편집 시작 시 placeholder 제거
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.gray
        }
    }

    // UITextViewDelegate - 편집 종료 시 빈 텍스트 처리
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "원하는 팀 조건을 입력해주세요"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // Firestore에 데이터 저장
    func saveToFirestore() {
        // 선택된 체크박스 주석 내용 가져오기
        let checkBoxTitles = [
            checkBoxButton1.isSelected ? "공모전" : nil,
            checkBoxButton2.isSelected ? "비교과" : nil,
            checkBoxButton3.isSelected ? "경진대회" : nil,
            checkBoxButton4.isSelected ? "동아리" : nil,
            checkBoxButton5.isSelected ? "소모임" : nil,
            checkBoxButton6.isSelected ? "기타" : nil
        ].compactMap { $0 } // nil 제거
        
        let activityType = checkBoxTitles.first ?? "null" // 첫 번째 선택된 체크박스
        
        // 대면 여부 설정
        let faceToFace = faceButton.isEnabled == false
        
        // Firestore에 저장할 데이터
        let data: [String: Any?] = [
            "제목": teamNameTextField.text ?? "null",
            "모집 학과": majorButton.title(for: .normal) ?? "null",
            "기간": periodButton.title(for: .normal) ?? "null",
            "인원": Int(personalButton.title(for: .normal) ?? "0") ?? 0,
            "설명": textTextView.text.isEmpty || textTextView.textColor == UIColor.lightGray ? "null" : textTextView.text,
            "활동 이름": activityNameTextField.text ?? "null",
            "대면 여부": faceToFace,
            "활동 종류": activityType,
            "현재 인원": 1
        ]
        
        // 팀 컬렉션에 저장 (team2, team3 등 자동 문서 이름 생성)
        let collectionRef = db.collection("팀")
        
        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                print("Firestore 문서 읽기 오류: \(error)")
                return
            }
            
            let nextTeamNumber = (snapshot?.documents.count ?? 0) + 2 // team2부터 시작
            let documentID = "team\(nextTeamNumber)"
            
            collectionRef.document(documentID).setData(data as [String : Any]) { error in
                if let error = error {
                    print("Firestore 저장 오류: \(error)")
                } else {
                    print("Firestore 저장 성공: \(documentID)")
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // 이전 화면 복구
        dismiss(animated: false, completion: nil) // 애니메이션 없이 닫기
    }
    
    // 등록 버튼 액션
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveToFirestore()
    }
    
    // 키보드를 숨기는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
        
}
