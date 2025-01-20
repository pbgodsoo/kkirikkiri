//
//  ActivityDetailViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/4/24.
//

import UIKit
import FirebaseFirestore

class ActivityDetailViewController: UIViewController {
    
    @IBOutlet var activityTitleLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var activityImageView: UIImageView!
    
    var documentID: String? // 이전 화면에서 전달받은 문서 ID
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // 이전 화면 복구
        dismiss(animated: false, completion: nil) // 애니메이션 없이 닫기
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Firestore에서 데이터 로드
        if let documentID = documentID {
            fetchDataFromFirestore(documentID: documentID)
        } else {
            print("문서 ID가 전달되지 않았습니다.")
        }
    }
    
    // Firestore에서 데이터 읽기
    func fetchDataFromFirestore(documentID: String) {
        let db = Firestore.firestore()
        
        db.collection("비교과활동").document(documentID).getDocument { document, error in
            if let error = error {
                print("Firestore 데이터를 가져오는 중 오류 발생: \(error)")
                return
            }
            
            guard let data = document?.data() else {
                print("문서가 존재하지 않습니다.")
                return
            }
            
            // 필드 데이터를 가져와 UILabel에 할당
            self.activityTitleLabel.text = data["활동이름"] as? String ?? "제목 없음"
            self.typeLabel.text = data["활동종류"] as? String ?? "유형 없음"
            self.hostLabel.text = data["주최"] as? String ?? "주최 없음"
            self.locationLabel.text = data["장소"] as? String ?? "장소 없음"
            self.detailLabel.text = data["상세설명"] as? String ?? "상세내용 없음"
            
            // 시작날짜와 마감날짜 처리
            if let startDate = data["시작날짜"] as? Timestamp {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                self.startTimeLabel.text = dateFormatter.string(from: startDate.dateValue())
            } else {
                self.startTimeLabel.text = "시작 날짜 없음"
            }
            
            if let endDate = data["마감날짜"] as? Timestamp {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                self.endTimeLabel.text = dateFormatter.string(from: endDate.dateValue())
            } else {
                self.endTimeLabel.text = "마감 날짜 없음"
            }
            
            // 다드림포인트 처리
            if let points = data["다드림포인트"] as? Int {
                self.pointLabel.text = "\(points)"
            } else {
                self.pointLabel.text = "0"
            }
            
            // 활동이미지 처리
            if let base64String = data["이미지"] as? String {
                self.activityImageView.image = self.decodeBase64ToImage(base64String: base64String)
            } else {
                print("Base64 이미지 데이터가 없습니다.")
                self.activityImageView.image = UIImage(named: "placeholder") // 기본 이미지
            }
            
        }
    }
    
    // Base64 문자열을 UIImage로 변환
    func decodeBase64ToImage(base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else {
            print("Base64 문자열을 데이터로 변환할 수 없습니다.")
            return nil
        }
        return UIImage(data: imageData)
    }
}
