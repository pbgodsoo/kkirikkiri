//
//  TeamViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/5/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TeamViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var bellButton: UIButton!
    @IBOutlet var checkBoxView: UIView!
    @IBOutlet var checkBoxButton1: UIButton!
    @IBOutlet var checkBoxButton2: UIButton!
    @IBOutlet var checkBoxButton3: UIButton!
    @IBOutlet var checkBoxButton4: UIButton!
    @IBOutlet var checkBoxButton5: UIButton!
    @IBOutlet var checkBoxButton6: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var teamMakeButton: UIButton!
    
    var tableTitle: [String] = []
    var personalLB: [String] = []
    var classification: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UITapGestureRecognizer 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //끼리끼리 폰트
        titleLabel.font = UIFont(name: "BMHANNAProOTF", size: 18)
        
        //검색 textField
        searchTextField.layer.cornerRadius = 12
        searchTextField.delegate = self // UITextFieldDelegate 설정
        
        // bellButton
        bellButton.imageView?.contentMode = .scaleAspectFill
        
        // 검색창// UITextField 왼쪽에 아이콘 추가 코드
        let searchIcon = UIImageView(image: UIImage(named: "searchIcon"))
        //searchIcon.tintColor = .gray // 아이콘 색상 설정
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 12, y: 0, width: 20, height: 20) // 아이콘 크기 설정

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20)) // 여백 포함
        paddingView.addSubview(searchIcon)

        // UITextField의 왼쪽 뷰에 추가
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        
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
        
        
        // 팀 만들기 버튼
        teamMakeButton.layer.cornerRadius = 12
        teamMakeButton.clipsToBounds = true
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyTable2ViewCell.nib(), forCellReuseIdentifier: "Cell2")
        
        // Firestore에서 초기 데이터 가져오기
        fetchTeamData(withTypes: [], searchText: nil)
    }
    
    func fetchTeamData(withTypes selectedTypes: [String], searchText: String?) {
        let db = Firestore.firestore()
        var query: Query = db.collection("팀")
        
        if !selectedTypes.isEmpty {
            query = query.whereField("활동 종류", in: selectedTypes)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Firestore 데이터를 가져오는 중 오류 발생: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("데이터가 없습니다.")
                return
            }
            
            var filteredDocuments = documents
            
            // 검색어 필터링
            if let searchText = searchText, !searchText.isEmpty {
                filteredDocuments = documents.filter { document in
                    let data = document.data()
                    let title = data["제목"] as? String ?? ""
                    let description = data["설명"] as? String ?? ""
                    return title.lowercased().contains(searchText.lowercased()) || description.lowercased().contains(searchText.lowercased())
                }
            }
            
            self.updateTableData(with: filteredDocuments)
        }
    }
    
    func updateTableData(with documents: [QueryDocumentSnapshot]) {
        self.tableTitle = []
        self.personalLB = []
        self.classification = []
        
        for document in documents {
            let data = document.data()
            
            // 제목 필드
            self.tableTitle.append(data["제목"] as? String ?? "제목 없음")
            
            // 인원 필드
            if let currentMembers = data["현재인원"] as? Int, let maxMembers = data["인원"] as? Int {
                self.personalLB.append("인원 : [\(currentMembers)/\(maxMembers)]")
            } else {
                self.personalLB.append("인원 정보 없음")
            }
            
            // classification 생성
            var classificationString = ""
            if let activityType = data["활동 종류"] as? String {
                classificationString += "\(activityType) | "
            }
            if let isOffline = data["대면여부"] as? Bool {
                classificationString += isOffline ? "대면 | " : "비대면 | "
            }
            if let duration = data["기간"] as? String {
                classificationString += "\(duration) | "
            }
            if let department = data["모집 학과"] as? String {
                classificationString += department
            }
            self.classification.append(classificationString.trimmingCharacters(in: CharacterSet(charactersIn: " |")))
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // 검색 텍스트 변경 시 호출
    @objc func searchTextChanged() {
        fetchTeamData(withTypes: getSelectedTypes(), searchText: searchTextField.text)
    }
    // 체크박스 상태 변경
    @IBAction func toggleCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle() // 선택 상태 변경
        fetchTeamData(withTypes: getSelectedTypes(), searchText: searchTextField.text)
    }
    
    // 팀만들기 페이지 이동
    @IBAction func teamMakeButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let teamMakeVC = storyboard.instantiateViewController(withIdentifier: "TeamMakeViewController") as? TeamMakeViewController else {
            return
        }
        
        // 화면 전환 스타일 설정
        teamMakeVC.modalPresentationStyle = .fullScreen
        
        // 화면 전환
        present(teamMakeVC, animated: true, completion: nil)
    }
    
    // 선택된 체크박스 필터 가져오기
    func getSelectedTypes() -> [String] {
        var selectedTypes: [String] = []
        if checkBoxButton1.isSelected { selectedTypes.append("공모전") }
        if checkBoxButton2.isSelected { selectedTypes.append("비교과") }
        if checkBoxButton3.isSelected { selectedTypes.append("경진대회") }
        if checkBoxButton4.isSelected { selectedTypes.append("동아리") }
        if checkBoxButton5.isSelected { selectedTypes.append("소모임") }
        if checkBoxButton6.isSelected { selectedTypes.append("기타") }
        return selectedTypes
    }
    
    // 키보드를 숨기는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// tableView
extension TeamViewController: UITableViewDataSource, UITableViewDelegate {
    // 상세화면 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "activityDetail")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil) // 애니메이션 없이 전환
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! MyTable2ViewCell
        cell.tableTitleLabel.text = tableTitle[indexPath.row]
        cell.classificationLabel.text = classification[indexPath.row]
        cell.personalLabel.text = personalLB[indexPath.row]
        return cell
    }
    
    
}

extension TeamViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        fetchTeamData(withTypes: getSelectedTypes(), searchText: updatedText)
        return true
    }
}
