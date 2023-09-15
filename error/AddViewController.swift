// 할일 작성 페이지

import UIKit

class AddViewController: UIViewController {
    private var loadingView: UIView?

    // 제목 라벨
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "제 목"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        // titleLabel.textAlignment = .center

        return titleLabel
    }()

    // 제목 텍스트필드
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.placeholder = "제목을 입력해주세요."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 13.0
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always

        return textField
    }()

    // 내용 라벨
    let contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

        contentLabel.text = "내 용"
        contentLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentLabel.textColor = .label
        // contentLabel.textAlignment = .center

        return contentLabel
    }()

    // 내용 텍스트뷰
    lazy var contentTextView: UITextView = {
        let contentTextView = UITextView()
        contentTextView.translatesAutoresizingMaskIntoConstraints = false

        contentTextView.text = "내용을 입력해주세요."
        contentTextView.font = UIFont.systemFont(ofSize: 17)
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 15.0
        contentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 5, bottom: 12, right: 5)
        contentTextView.textColor = .placeholderText

        contentTextView.delegate = self

        return contentTextView
    }()

    // 로딩화면
    private lazy var loadingScreenView: UIView = {
        // 로딩 화면 뷰 생성
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = .white
        loadingView.alpha = 0.5
        loadingView.isHidden = true // 초기 상태는 숨김으로 설정

        let activityIndicator = UIActivityIndicatorView(style: .medium)

        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)

        return loadingView
    }()

    // MARK: - 스택뷰

    // 제목 스택뷰
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, titleTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 16

        return stackView
    }()

    // 내용 스택뷰
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [contentLabel, contentTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 16

        return stackView
    }()

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setUpViews()
        setupNavigationBar()
        setUpConstraints()

        titleTextField.delegate = self
        contentTextView.delegate = self
    }

    // 화면에 보여지는 곳
    private func setUpViews() {
        view.addSubview(titleStackView)
        view.addSubview(contentStackView)
        view.addSubview(loadingScreenView)
    }

    // MARK: - 레이아웃

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // 제목 스택뷰
            titleStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 70),
            titleStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            titleStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            titleStackView.heightAnchor.constraint(equalToConstant: 80),

            // 제목 라벨
            titleLabel.topAnchor.constraint(equalTo: titleStackView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: titleStackView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),

            // 제목 텍스트필드
            titleTextField.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: titleStackView.trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),

            // 내용 스택뷰
            contentStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 30),
            contentStackView.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: titleStackView.trailingAnchor),
            contentStackView.heightAnchor.constraint(equalToConstant: 200),

            // 내용 라벨
            contentLabel.topAnchor.constraint(equalTo: contentStackView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 5),
            contentLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: 20),

            // 내용 텍스트뷰
            contentTextView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -150),
            contentTextView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }

    // MARK: - 상단바 아이템

    private func setupNavigationBar() {
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("완료", for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.tintColor = UIColor.black

        rightButton.addTarget(self, action: #selector(doneButtonTap), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: rightButton)

        navigationItem.rightBarButtonItem = barButtonItem

        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.label,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        navigationItem.title = "할일 추가하기"
    }

    // MARK: - 기능, 액션

    @objc func doneButtonTap() {
        loadingScreenView.isHidden = false // 로딩 화면 보여주기

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { // 0.5초 후 실행되는 클로저 추가
            self.loadingScreenView.isHidden = true // 로딩 화면 숨기기
            self.dismiss(animated: true, completion: nil) // 현재 ViewController 닫기
        }
    }

    // 로딩화면 사라짐
    private func dismissLoadingScreen() {
        guard let loadingView = loadingView else {
            return
        }

        loadingView.removeFromSuperview()

        self.loadingView = nil
    }

    // 빈화면 터치시 키보드 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Delegate

extension AddViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == titleTextField && textField.text == "제목을 입력해주세요." {
            textField.text = nil
            textField.textColor = .label
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField && (textField.text == nil || textField.text!.isEmpty) {
            textField.text = "제목을 입력해주세요."
            textField.textColor = .placeholderText
        }
    }
}

extension AddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard contentTextView.textColor == .placeholderText else { return }
        contentTextView.textColor = .label
        contentTextView.text = nil
        contentTextView.font = UIFont.systemFont(ofSize: 16)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.text = "내용을 입력해주세요."
            contentTextView.textColor = .placeholderText
            contentTextView.font = UIFont.systemFont(ofSize: 16)
        }
    }
}
