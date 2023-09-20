// 프로필 수정페이지

import UIKit

class ProfileViewController: UIViewController {
    // 사용자 이름 라벨
    private lazy var userNameLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "사용자 이름"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label

        return titleLabel
    }()

    // 사용자 이름 텍스트필드
    lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "사용자 이름.."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderColor = UIColor.systemBackground.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 0.0
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always

        // 밑줄 추가
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .lightGray

        textField.addSubview(underlineView)

        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
        ])

        return textField
    }()

    // 이름 라벨
    private lazy var nameLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.text = "이름"
        contentLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentLabel.textColor = .label

        return contentLabel
    }()

    // 이름 텍스트필드
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "이름.."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderColor = UIColor.systemBackground.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 0.0
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always

        // 밑줄 추가
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .lightGray

        textField.addSubview(underlineView)

        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
        ])

        return textField
    }()

    // 소개 라벨
    private lazy var introduceLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.text = "소개"
        contentLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentLabel.textColor = .label

        return contentLabel
    }()

    // 소개 텍스트필드
    lazy var introduceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "소개.."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderColor = UIColor.systemBackground.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 0.0
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always

        // 밑줄 추가
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .lightGray

        textField.addSubview(underlineView)

        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
        ])

        return textField
    }()

    // 사용자 이름 스택뷰
    private lazy var usernameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, userNameTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 10

        return stackView
    }()

    // 이름 스택뷰
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 10

        return stackView
    }()

    // 소개 스택뷰
    private lazy var introduceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [introduceLabel, introduceTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 10

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        profileSetupNavigationBar()
        profileSetupViews()
        setUpConstraints()
    }

    private func profileSetupViews() {
        view.addSubview(usernameStackView)
        view.addSubview(nameStackView)
        view.addSubview(introduceStackView)
    }

    // 상단 바
    private func profileSetupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.black

        // 타이틀
        let titleLabel = UILabel()
        titleLabel.text = "프로필 편집"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel

        // 완료 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(editDoneButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.black
    }

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // 사용자 이름 스택뷰
            usernameStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 80),
            usernameStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            usernameStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            usernameStackView.heightAnchor.constraint(equalToConstant: 35),

            userNameLabel.centerYAnchor.constraint(equalTo: usernameStackView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            userNameLabel.widthAnchor.constraint(equalToConstant: 90),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),

            userNameTextField.centerYAnchor.constraint(equalTo: usernameStackView.centerYAnchor),
            userNameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),

            // 이름 스택뷰
            nameStackView.topAnchor.constraint(equalTo: usernameStackView.bottomAnchor, constant: 40),
            nameStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            nameStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            nameStackView.heightAnchor.constraint(equalToConstant: 35),

            nameLabel.centerYAnchor.constraint(equalTo: nameStackView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 90),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),

            nameTextField.centerYAnchor.constraint(equalTo: nameStackView.centerYAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),

            // 소개 스택뷰
            introduceStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 40),
            introduceStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            introduceStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            introduceStackView.heightAnchor.constraint(equalToConstant: 35),

            introduceLabel.centerYAnchor.constraint(equalTo: introduceStackView.centerYAnchor),
            introduceLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            introduceLabel.widthAnchor.constraint(equalToConstant: 90),
            introduceLabel.heightAnchor.constraint(equalToConstant: 20),

            introduceTextField.centerYAnchor.constraint(equalTo: introduceStackView.centerYAnchor),
            introduceTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
        ])
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func editDoneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)

        if userNameTextField.text == "" {
            userNameTextField.placeholder = "사용자 이름.."
        }

        if nameTextField.text == "" {
            nameTextField.placeholder = "이름.."
        }

        if introduceTextField.text == "" {
            introduceTextField.placeholder = "소개.."
        }
    }
}
