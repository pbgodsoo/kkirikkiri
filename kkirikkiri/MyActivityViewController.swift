//
//  MyActivityViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/6/24.
//

import UIKit


class MyActivityViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var tableTitle: [String] = [
        "2024-2 독서토론하KU",
        "2024-2 K-MOOC 캐릭터 공모전",
        "2024-1 학습공동체",
        "2022-1 직무로드맵 공모전",
        "2021-1 영어 튜터링-튜티",
        "2021-1 영어 튜터링-튜티"
    ]
    var classification: [String] = [
        "비교과 | 대면 | 8주",
        "공모전 | 대면 | 4주 | 디자인대학",
        "동아리",
        "소모임 | 컴퓨터공학과",
        "비교과 | 대면 | 8주",
        "비교과 | 대면 | 8주"
    ]
    var state: [String] = [
        "모집중",
        "활동 종료",
        "활동 종료",
        "활동 종료",
        "활동 종료",
        "활동 종료"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyTable3ViewCell.nib(), forCellReuseIdentifier: "Cell3")
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // 이전 화면 복구
        dismiss(animated: false, completion: nil) // 애니메이션 없이 닫기
    }
}


// tableView
extension MyActivityViewController: UITableViewDataSource, UITableViewDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! MyTable3ViewCell
        cell.tableTitleLabel.text = tableTitle[indexPath.row]
        cell.classificationLabel.text = classification[indexPath.row]
        cell.stateLabel.text = state[indexPath.row]
        return cell
    }
    
    
}
