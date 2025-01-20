import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    private var currentViewController: UIViewController?
    
    // 상단 타이틀
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "끼리끼리"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 알림 버튼
    private let notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupMainContent()
        
        // 초기 화면 설정
        switchToViewController(HomeViewController())
        /*updateTabBarSelection(index: 0) // 초기 상태로 첫 번째 버튼 활성화
         */
         
    }
    
    // MARK: - Custom Tab Bar 설정
    
    
    // MARK: - 탭 버튼 클릭 처리
   /* @objc private func tabButtonTapped(_ sender: UIButton) {
        updateTabBarSelection(index: sender.tag) // 선택 상태 업데이트
        
        // 화면 전환 처리
       
    }
    */
    
    // MARK: - 탭 버튼 선택 상태 업데이트
    /*private func updateTabBarSelection(index: Int) {
        for (buttonIndex, button) in tabButtons.enumerated() {
            if buttonIndex == index {
                // 선택된 버튼: 활성화된 아이콘 및 색상
                button.configuration?.image = UIImage(named: selectedImages[buttonIndex])
                button.configuration?.baseForegroundColor = .systemPurple
            } else {
                // 비활성화된 버튼: 기본 아이콘 및 색상
                button.configuration?.image = UIImage(named: images[buttonIndex])
                button.configuration?.baseForegroundColor = .gray
            }
        }
    }
    */
    // MARK: - 화면 전환 처리
    private func switchToViewController(_ viewController: UIViewController) {
        guard currentViewController !== viewController else { return }
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view) // `addSubview` 필수
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        viewController.didMove(toParent: self)
    }
    
    // MARK: - 메인 콘텐츠 레이아웃 설정
    private func setupMainContent() {
        // 상단 타이틀 및 알림 버튼 추가
        view.addSubview(titleLabel)
        view.addSubview(notificationButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notificationButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - HomeViewController
class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUIViews() // 홈 탭에서만 UIView 추가
    }
    
    private func setupUIViews() {
        // 첫 번째 박스: 체크리스트
        let checklistView = ChecklistView()
        checklistView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checklistView)
        
        let secondView = UIView()
                secondView.backgroundColor = UIColor(red: 0.0/255.0, green: 143.0/255.0, blue: 0.0/255.0, alpha: 0.30)
                secondView.layer.cornerRadius = 16
                secondView.layer.borderColor = UIColor(red: 0.922, green: 0.914, blue: 0.996, alpha: 1).cgColor
                secondView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(secondView)
        
        // 두 번째 박스
        let secondBox = ClickableStackView(data: ["직무로드맵 공모전", "2024 2학기 학습 공동체", "K-MOOC 해드림 서포터즈"])
        secondBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondBox)
        
        // 세 번째 박스
        let thirdView = UIView()
        thirdView.backgroundColor = UIColor(red: 0.0/255.0, green: 143.0/255.0, blue: 0.0/255.0, alpha: 0.30)
        thirdView.layer.cornerRadius = 16
        thirdView.layer.borderWidth = 1
        thirdView.layer.borderColor = UIColor(red: 0.922, green: 0.914, blue: 0.996, alpha: 1).cgColor
        thirdView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thirdView)

        let thirdLabel = UILabel()
        thirdLabel.text = "2024년 2학기 학습공동체"
        thirdLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        thirdLabel.textColor = .black
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdView.addSubview(thirdLabel)

        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progress = 0.25 // Example: 25% progress
        progressBar.tintColor = .systemRed
        progressBar.trackTintColor = .lightGray
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        thirdView.addSubview(progressBar)

        let progressLabel = UILabel()
        progressLabel.text = "25% 진행중"
        progressLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        progressLabel.textColor = .black
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdView.addSubview(progressLabel)
        
        // 네 번째 박스
        let fourthView = UIView()
        fourthView.backgroundColor = UIColor(red: 0.0/255.0, green: 143.0/255.0, blue: 0.0/255.0, alpha: 0.30)
        fourthView.layer.cornerRadius = 16
        fourthView.layer.borderWidth = 1
        fourthView.layer.borderColor = UIColor(red: 0.922, green: 0.914, blue: 0.996, alpha: 1).cgColor
        fourthView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fourthView)
        
        // 네 번째 박스 내부 콘텐츠: 게시판 형식 추가
           let bulletinTitleLabel = UILabel()
           bulletinTitleLabel.text = "2024년 2학기 학습공동체"
           bulletinTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
           bulletinTitleLabel.textColor = .black
           bulletinTitleLabel.translatesAutoresizingMaskIntoConstraints = false
           fourthView.addSubview(bulletinTitleLabel)

           let bulletinStackView = UIStackView()
           bulletinStackView.axis = .vertical
           bulletinStackView.spacing = 16
           bulletinStackView.translatesAutoresizingMaskIntoConstraints = false
           fourthView.addSubview(bulletinStackView)

           let bulletinItems: [(String, String)] = [
               ("공지사항입니다!", "5분 전 | 강호원"),
               ("공지사항입니다!", "30분 전 | 강윤호"),
               ("공지사항입니다!", "3시간 전 | 강대훈"),
               ("공지사항입니다!", "11/25 | 박범수")
           ]

           for item in bulletinItems {
               let row = UIView()
               row.translatesAutoresizingMaskIntoConstraints = false

               let titleLabel = UILabel()
               titleLabel.text = item.0
               titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
               titleLabel.textColor = .black
               titleLabel.translatesAutoresizingMaskIntoConstraints = false
               row.addSubview(titleLabel)

               let subtitleLabel = UILabel()
               subtitleLabel.text = item.1
               subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
               subtitleLabel.textColor = .gray
               subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
               row.addSubview(subtitleLabel)

               let separator = UIView()
               separator.backgroundColor = UIColor(red: 0.0/255.0, green: 143.0/255.0, blue: 0.0/255.0, alpha: 0.30)
               separator.translatesAutoresizingMaskIntoConstraints = false
               row.addSubview(separator)

               // 모든 공지사항 간의 간격을 일정하게 설정
               NSLayoutConstraint.activate([
                   titleLabel.topAnchor.constraint(equalTo: row.topAnchor),
                   titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor),
                   titleLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor),

                   subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                   subtitleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor),
                   subtitleLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor),

                   separator.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
                   separator.leadingAnchor.constraint(equalTo: row.leadingAnchor),
                   separator.trailingAnchor.constraint(equalTo: row.trailingAnchor),
                   separator.heightAnchor.constraint(equalToConstant: 1),
                   separator.bottomAnchor.constraint(equalTo: row.bottomAnchor)
               ])

               bulletinStackView.addArrangedSubview(row)
           }

        // MARK: Constraints
        NSLayoutConstraint.activate([
            checklistView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            checklistView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            checklistView.widthAnchor.constraint(equalToConstant: 120),
            checklistView.heightAnchor.constraint(equalToConstant: 120),
            
            secondBox.leadingAnchor.constraint(equalTo: checklistView.trailingAnchor, constant: 32),
            secondBox.topAnchor.constraint(equalTo: checklistView.topAnchor, constant: 16),
            secondBox.widthAnchor.constraint(equalToConstant: 208),
            secondBox.heightAnchor.constraint(equalToConstant: 96),
            
            // 두 번째 뷰
            secondView.leadingAnchor.constraint(equalTo: checklistView.trailingAnchor, constant: 16),
                        secondView.topAnchor.constraint(equalTo: checklistView.topAnchor),
                        secondView.widthAnchor.constraint(equalToConstant: 208),
                        secondView.heightAnchor.constraint(equalToConstant: 120),
            
            // 세 번째 박스
            thirdView.topAnchor.constraint(equalTo: checklistView.bottomAnchor, constant: 16),
            thirdView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thirdView.widthAnchor.constraint(equalToConstant: 344),
            thirdView.heightAnchor.constraint(equalToConstant: 116),
            
            thirdLabel.topAnchor.constraint(equalTo: thirdView.topAnchor, constant: 16),
            thirdLabel.leadingAnchor.constraint(equalTo: thirdView.leadingAnchor, constant: 16),
            
            progressLabel.topAnchor.constraint(equalTo: thirdLabel.bottomAnchor, constant: 8),
            progressLabel.leadingAnchor.constraint(equalTo: thirdView.leadingAnchor, constant: 16),
            
            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: thirdView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: thirdView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            // 네 번째 박스
            fourthView.topAnchor.constraint(equalTo: thirdView.bottomAnchor, constant: 16),
                        fourthView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        fourthView.widthAnchor.constraint(equalToConstant: 344),
                        fourthView.heightAnchor.constraint(equalToConstant: 335),
            
            bulletinTitleLabel.topAnchor.constraint(equalTo: fourthView.topAnchor, constant: 16),
                    bulletinTitleLabel.leadingAnchor.constraint(equalTo: fourthView.leadingAnchor, constant: 16),
                    bulletinTitleLabel.trailingAnchor.constraint(equalTo: fourthView.trailingAnchor, constant: -16),

                    bulletinStackView.topAnchor.constraint(equalTo: bulletinTitleLabel.bottomAnchor, constant: 16),
                    bulletinStackView.leadingAnchor.constraint(equalTo: fourthView.leadingAnchor, constant: 16),
                    bulletinStackView.trailingAnchor.constraint(equalTo: fourthView.trailingAnchor, constant: -16),
                    bulletinStackView.bottomAnchor.constraint(equalTo: fourthView.bottomAnchor, constant: -16),

            
        ])
    }
}

// MARK: - ChecklistView
class ChecklistView: UIView {
    private let tasks = ["1과목 기출문제 풀이", "취약점 분석", "오답노트 정리하기", "최종 보고서 제출"]
    private var buttons: [UIButton] = []
    private var labels: [UILabel] = []
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(red: 0.0/255.0, green: 143.0/255.0, blue: 0.0/255.0, alpha: 0.30)
        self.layer.cornerRadius = 24
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.922, green: 0.914, blue: 0.996, alpha: 1).cgColor
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
        
        for (index, task) in tasks.enumerated() {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "square"), for: .normal)
            button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            button.tag = index
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(handleCheck(_:)), for: .touchUpInside)
            containerView.addSubview(button)
            buttons.append(button)
            
            let label = UILabel()
            label.text = task
            label.font = UIFont.systemFont(ofSize: 10)
            label.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(label)
            labels.append(label)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: 16),
                button.heightAnchor.constraint(equalToConstant: 16),
                
                label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 6),
                label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
            
            NSLayoutConstraint.activate([
                containerView.heightAnchor.constraint(equalToConstant: 16)
            ])
            
            stackView.addArrangedSubview(containerView)
        }
    }
    
    @objc private func handleCheck(_ sender: UIButton) {
        sender.isSelected.toggle()
        let label = labels[sender.tag]
        label.textColor = sender.isSelected ? .lightGray : .black
        label.attributedText = sender.isSelected
        ? NSAttributedString(string: label.text ?? "", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        : NSAttributedString(string: label.text ?? "", attributes: [:])
    }
}

// MARK: - ClickableStackView
class ClickableStackView: UIView {
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    
    init(data: [String]) {
        super.init(frame: .zero)
        setupView(data: data)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(data: [String]) {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        for (index, item) in data.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(item, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            button.setTitleColor(.black, for: .normal)
        }
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        sender.setTitleColor(.systemBlue, for: .normal)
    }
}


// MARK: - SwiftUI 시뮬레이터
#if DEBUG
import SwiftUI
struct ViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    func makeUIViewController(context: Context) -> some UIViewController { ViewController() }
}

struct ViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        ViewControllerPresentable().ignoresSafeArea()
    }
}
#endif

