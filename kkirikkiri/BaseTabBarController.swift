//
//  BaseTabBarController.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/9/24.
//

import UIKit

class BaseTabBarController: UIViewController {
    private let tabBarView = UIView()
    private let tabButtons: [UIButton] = [
        UIButton(type: .system),
        UIButton(type: .system),
        UIButton(type: .system),
        UIButton(type: .system)
    ]
    private let titles = ["홈", "팀", "비교과 활동", "마이페이지"]
    private let images = ["home0_tab", "team0_tab", "activity0_tab", "mypage0_tab"]
    private let selectedImages = ["home1_tab", "team1_tab", "activity1_tab", "mypage1_tab"]
    private var currentViewController: UIViewController?
    private let font = UIFont.systemFont(ofSize: 10, weight: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        // 초기 화면 설정
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            switchToViewController(initialViewController)
            updateTabBarSelection(index: 0)
        } else {
            print("초기 ViewController를 찾을 수 없습니다.")
        }
        
    }
    
    private func setupCustomTabBar() {
        tabBarView.backgroundColor = .white
        tabBarView.layer.cornerRadius = 20
        tabBarView.layer.shadowColor = UIColor.black.cgColor
        tabBarView.layer.shadowOpacity = 0.3
        tabBarView.layer.shadowRadius = 8
        tabBarView.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let shadowPath = UIBezierPath()
            shadowPath.move(to: CGPoint(x: 0, y: 0))
            shadowPath.addLine(to: CGPoint(x: self.tabBarView.bounds.width, y: 0))
            shadowPath.addLine(to: CGPoint(x: self.tabBarView.bounds.width, y: 5)) // 위쪽 그림자 범위
            shadowPath.addLine(to: CGPoint(x: 0, y: 5))
            shadowPath.close()
            self.tabBarView.layer.shadowPath = shadowPath.cgPath
        }
        
        NSLayoutConstraint.activate([
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let buttonWidth = UIScreen.main.bounds.width / CGFloat(tabButtons.count)
        for (index, button) in tabButtons.enumerated() {
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(named: images[index])
            configuration.title = titles[index]
            configuration.imagePlacement = .top
            configuration.imagePadding = 4
            configuration.attributedTitle = AttributedString(titles[index], attributes: AttributeContainer([.font: font]))
            button.configuration = configuration
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            tabBarView.addSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: CGFloat(index) * buttonWidth),
                button.topAnchor.constraint(equalTo: tabBarView.topAnchor),
                button.widthAnchor.constraint(equalToConstant: buttonWidth),
                button.heightAnchor.constraint(equalTo: tabBarView.heightAnchor)
            ])
        }
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        updateTabBarSelection(index: sender.tag)
        let viewController: UIViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 스토리보드 이름 확인!
        switch sender.tag {
        case 0:
            viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        case 1:
            viewController = storyboard.instantiateViewController(withIdentifier: "team") as! TeamViewController
        case 2:
            viewController = storyboard.instantiateViewController(withIdentifier: "activity") as! ActivityViewController
        case 3:
            // MyPageViewController를 스토리보드에서 초기화
            viewController = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
        default:
            fatalError("Invalid tab index")
        }
        switchToViewController(viewController)
    }
    
    private func updateTabBarSelection(index: Int) {
        for (buttonIndex, button) in tabButtons.enumerated() {
            if buttonIndex == index {
                button.configuration?.image = UIImage(named: selectedImages[buttonIndex])
                button.configuration?.baseForegroundColor = .systemPurple
            } else {
                button.configuration?.image = UIImage(named: images[buttonIndex])
                button.configuration?.baseForegroundColor = .gray
            }
        }
    }
    
    private func switchToViewController(_ viewController: UIViewController) {
        guard currentViewController !== viewController else { return }
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(viewController.view, belowSubview: tabBarView)
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: tabBarView.topAnchor)
        ])
        viewController.didMove(toParent: self)
        currentViewController = viewController
    }
}

