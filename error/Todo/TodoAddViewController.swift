
import UIKit

final class TodoAddViewController: UIViewController {
    private var initialHeightConstraint: NSLayoutConstraint?
    private var loadingView: UIView?
    private let existingText: String?
    var selectedSectionIndex: Int?
    var initialText: String?
    var delegate: AddTodoDelegate?

    init(existingText: String? = nil) {
        self.existingText = existingText
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "제 목"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label

        return titleLabel
    }()

    private lazy var titleTextField: UITextField = {
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

    private lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.text = "내 용"
        contentLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentLabel.textColor = .label

        return contentLabel
    }()

    private lazy var contentTextView: UITextView = {
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

    // 상단바
    private func setupAddNavigationBar() {
        let rightButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTap))
        rightButton.tintColor = UIColor.label
        navigationItem.rightBarButtonItem = rightButton

        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 21),
            .foregroundColor: UIColor.label,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        navigationItem.title = "할일 추가하기"
    }

    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        titleTextField.delegate = self
        contentTextView.delegate = self

        if let existingText = existingText {
            titleTextField.text = existingText
        }

        getSavedData()
        setUpViews()
        setupAddNavigationBar()
        sepupInitialHeightConstraint()
        setUpConstraints()
    }

    // 화면에 보여지는 곳
    private func setUpViews() {
        view.addSubview(titleStackView)
        view.addSubview(contentStackView)
    }

    // 레이아웃
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

    private func getSavedData() {
        if let savedTitle = UserDefaults.standard.string(forKey: "title") {
            titleTextField.text = savedTitle
        }

        if let savedContent = UserDefaults.standard.string(forKey: "content") {
            contentTextView.text = savedContent
        }
    }

    // 완료 버튼 눌렀을때
    @objc func doneButtonTap(_sender: Any) {
        guard let titleText = titleTextField.text,
              let contentText = contentTextView.text,
              let sectionIndex = selectedSectionIndex
        else { return }
        if titleText.isEmpty && contentText.isEmpty {
            return
        }
        showLoadingScreen()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.delegate?.didSaveNewTodo(todo: titleText + "\n" + contentText, section: sectionIndex)

            self.dismissLoadingScreen()
            self.dismiss(animated: true)
        }
    }

    // 로딩화면
    private func showLoadingScreen() {
        // 로딩 화면 뷰 생성
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = .white
        loadingView.alpha = 0.5

        let activityIndicator = UIActivityIndicatorView(style: .medium)

        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)

        self.loadingView = loadingView
    }

    // 로딩화면 사라짐
    private func dismissLoadingScreen() {
        guard let loadingView = loadingView else {
            return
        }

        loadingView.removeFromSuperview()

        self.loadingView = nil
    }

    private func sepupInitialHeightConstraint() {
        initialHeightConstraint = contentTextView.heightAnchor.constraint(equalToConstant: 150)
        initialHeightConstraint?.isActive = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension TodoAddViewController: UITextFieldDelegate {
    func textFieldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        return true
    }
}

extension TodoAddViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.isScrollEnabled {
            initialHeightConstraint?.constant = textView.contentSize.height
        }

        let maxHeight: CGFloat = 100

        if textView.contentSize.height >= maxHeight {
            textView.isScrollEnabled = true
            initialHeightConstraint?.constant = maxHeight
        } else {
            textView.isScrollEnabled = false
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard contentTextView.textColor == .placeholderText else { return }
        contentTextView.textColor = .label
        contentTextView.text = nil
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.text = "내용을 입력해주세요."
            contentTextView.textColor = .placeholderText
        }
    }
}

extension TodoAddViewController {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
