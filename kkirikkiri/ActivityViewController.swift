//
//  ActivityViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/2/24.
//

import UIKit
import FirebaseFirestore

class ActivityViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchTextField: UITextField! // 검색창
    @IBOutlet var bellButton: UIButton!
    @IBOutlet var checkBoxView: UIView!
    @IBOutlet var checkBoxButton1: UIButton! // 공모전
    @IBOutlet var checkBoxButton2: UIButton! // 세미나
    @IBOutlet var checkBoxButton3: UIButton! // 워크숍
    @IBOutlet var checkBoxButton4: UIButton! // 특강
    @IBOutlet var checkBoxButton5: UIButton! // 튜터링
    @IBOutlet var checkBoxButton6: UIButton! // 경진대회
    @IBOutlet var tableView: UITableView!
    
    var tableTitle: [String] = []
    var period: [String] = []
    var period2: [String] = []
    
    
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
        
        // 체크박스 뷰 설정
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
        
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.idetifier)
        
        // Firestore에서 데이터 가져오기
        fetchDataFromFirestore(withTypes: [], searchText: nil)
    }
    
    // Firestore에서 데이터 읽기
    func fetchDataFromFirestore(withTypes selectedTypes: [String], searchText: String?) {
        let db = Firestore.firestore()
        var query: Query = db.collection("비교과활동")
        
        if !selectedTypes.isEmpty {
            query = query.whereField("활동종류", in: selectedTypes)
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
            
            var filteredDocuments: [QueryDocumentSnapshot] = documents
            
            // 검색 텍스트 필터링
            if let searchText = searchText, !searchText.isEmpty {
                filteredDocuments = documents.filter { document in
                    let data = document.data()
                    let activityName = data["활동이름"] as? String ?? ""
                    let activityDescription = data["상세설명"] as? String ?? ""
                    return activityName.contains(searchText) || activityDescription.contains(searchText)
                }
            }
            
            // 데이터 배열 초기화
            self.tableTitle = []
            self.period = []
            self.period2 = []
            
            for document in filteredDocuments {
                let data = document.data()
                
                if let title = data["활동이름"] as? String {
                    self.tableTitle.append(title)
                } else {
                    self.tableTitle.append("제목 없음")
                }
                
                if let startDate = data["시작날짜"] as? Timestamp {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy.MM.dd(EEE)"
                    self.period.append("시작날짜 : \(dateFormatter.string(from: startDate.dateValue()))")
                } else {
                    self.period.append("시작날짜 : 날짜 없음")
                }
                
                if let endDate = data["마감날짜"] as? Timestamp {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy.MM.dd(EEE)"
                    self.period2.append("마감날짜 : \(dateFormatter.string(from: endDate.dateValue()))")
                } else {
                    self.period2.append("마감날짜 : 날짜 없음")
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // 체크박스 상태 변경
    @IBAction func toggleCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle() // 선택 상태 변경
        updateFilters()
    }
    
    // 선택된 체크박스를 기반으로 필터링 업데이트
    func updateFilters() {
        var selectedTypes: [String] = []
        
        // 각 체크박스 상태를 확인하고 활동 종류 추가
        if checkBoxButton1.isSelected { selectedTypes.append("공모전") }
        if checkBoxButton2.isSelected { selectedTypes.append("세미나") }
        if checkBoxButton3.isSelected { selectedTypes.append("워크숍") }
        if checkBoxButton4.isSelected { selectedTypes.append("특강") }
        if checkBoxButton5.isSelected { selectedTypes.append("튜터링") }
        if checkBoxButton6.isSelected { selectedTypes.append("경진대회") }
        
        // Firestore에서 필터링된 데이터 가져오기
        fetchDataFromFirestore(withTypes: selectedTypes, searchText: searchTextField.text)
    }
    // UITextFieldDelegate: 검색 텍스트 입력 처리
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        fetchDataFromFirestore(withTypes: getSelectedTypes(), searchText: updatedText)
        return true
    }
    
    func getSelectedTypes() -> [String] {
        var selectedTypes: [String] = []
        if checkBoxButton1.isSelected { selectedTypes.append("공모전") }
        if checkBoxButton2.isSelected { selectedTypes.append("세미나") }
        if checkBoxButton3.isSelected { selectedTypes.append("워크숍") }
        if checkBoxButton4.isSelected { selectedTypes.append("특강") }
        if checkBoxButton5.isSelected { selectedTypes.append("튜터링") }
        if checkBoxButton6.isSelected { selectedTypes.append("경진대회") }
        return selectedTypes
    }
    
    // 키보드를 숨기는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// tableView
extension ActivityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "activityDetail") as? ActivityDetailViewController else {
            return
        }
        
        // Firestore에서 문서 ID 가져오기
        let db = Firestore.firestore()
        db.collection("비교과활동").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            // 선택한 행에 해당하는 문서 ID를 전달
            let documentID = documents[indexPath.row].documentID
            detailVC.documentID = documentID
            
            DispatchQueue.main.async {
                // ActivityDetailViewController로 이동
                detailVC.modalPresentationStyle = .fullScreen
                self.present(detailVC, animated: false, completion: nil)
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.idetifier, for: indexPath) as! MyTableViewCell
        cell.tableTitleLabel.text = tableTitle[indexPath.row]
        cell.periodLabel.text = period[indexPath.row]
        cell.periodLabel2.text = period2[indexPath.row]
        return cell
    }
    
    
}
