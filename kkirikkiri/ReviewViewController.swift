//
//  ReviewViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ReviewViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var tableTitle: [String] = ["2021-1 학습공동체","2022 직무로드맵 공모전","독서토론하KU"]
    var textt: [String] = ["성실하게 참여해요","열정적이고 리더쉽이 있어요","지각을 자주해요"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyTable4ViewCell.nib(), forCellReuseIdentifier: "Cell4")
        
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        // 이전 화면 복구
        dismiss(animated: false, completion: nil) // 애니메이션 없이 닫기
    }
}

// tableView
extension ReviewViewController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! MyTable4ViewCell
        cell.tableTitleLabel.text = tableTitle[indexPath.row]
        cell.texttLabel.text = textt[indexPath.row]
        return cell
    }
    
    
}
