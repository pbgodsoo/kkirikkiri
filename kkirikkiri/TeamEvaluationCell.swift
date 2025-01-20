//
//  TeamEvaluationCell.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/10/24.
//

import UIKit

class TeamEvaluationCell: UITableViewCell {

    let teamButton: UIButton = {
        let button = UIButton(type: .system)
        // UIButtonConfiguration 사용
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = UIColor.systemGray6 // 버튼 배경색
        config.baseForegroundColor = UIColor.black // 텍스트 색상
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 16, bottom: 18, trailing: 0) // 내부 여백 설정 (왼쪽으로 밀기)
        
        button.configuration = config
        
        // 버튼의 수평 정렬 설정
        button.contentHorizontalAlignment = .leading // 텍스트를 버튼 내부의 왼쪽으로 배치

        // 버튼 스타일
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(teamButton)
        
        NSLayoutConstraint.activate([
            teamButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            teamButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            teamButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            teamButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
