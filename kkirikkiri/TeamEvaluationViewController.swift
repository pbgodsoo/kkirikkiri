//
//  TeamEvaluationViewController.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/10/24.
//

import UIKit

class TeamEvaluationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var contentView: UIView! // Interface Builder와 연결된 UIView
    struct Activity {
        let name: String
        let teamMembers: [String]
    }
    
    let tableView = UITableView()
    let userActivities: [Activity] = [
        Activity(name: "2024-1 학습공동체", teamMembers: ["컴퓨터공학과 강호원", "컴퓨터공학과 강윤호", "컴퓨터공학과 강대훈", "컴퓨터공학과 박경민"]),
        Activity(name: "2024-1 독서토론하KU", teamMembers: ["생명공학과 전민재", "생명공학과 박준수", "바이오의약학과 임수빈", "바이오의약학과 김현용"])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupTableHeaderView() // 상단 메시지 추가
        tableView.separatorStyle = .none // 경계선 제거
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TeamEvaluationCell.self, forCellReuseIdentifier: "TeamEvaluationCell")
        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setupTableHeaderView() {
        let headerView = UIView()
        headerView.backgroundColor = .white

        let headerLabel = UILabel()
        headerLabel.text = "평가하실 팀원을 선택해 주세요"
        headerLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
        ])

        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = 40
    }
    
    // UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return userActivities.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userActivities[section].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userActivities[section].teamMembers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamEvaluationCell", for: indexPath) as? TeamEvaluationCell else {
            return UITableViewCell()
        }

        let memberName = userActivities[indexPath.section].teamMembers[indexPath.row]
        cell.teamButton.setTitle(memberName, for: .normal)
        
        // 버튼 클릭 이벤트 추가
        cell.teamButton.tag = indexPath.row
        cell.teamButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        return cell
    }

    @objc func buttonTapped(_ sender: UIButton) {
        print("Button tapped: \(sender.tag)")
    }

    // UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // 셀 높이 조정
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        // 이전 화면 복구
        dismiss(animated: false, completion: nil) // 애니메이션 없이 닫기
    }
}
