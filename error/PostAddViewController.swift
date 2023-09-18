// 게시글 추가 페이지

import UIKit

protocol PostAddDelegate: AnyObject {
    func didCompletePost(with image: UIImage)
}

class PostAddViewController: UIViewController {
    weak var delegate: PostAddDelegate?
    var selectedImage: UIImage?

    private var loadingView: UIView?

    // 프로필 이미지뷰
    private lazy var postProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true

        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "cameraImage")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 60

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postProfileImageTapped))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }()

    // 그림자 뷰
    private lazy var postshadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false

        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 60

        return view
    }()

    // 이미지 추가 버튼
    private lazy var imageAddButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("이미지 추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 17)

        button.backgroundColor = UIColor.systemGray5
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(imageAddButtonTapped), for: .touchUpInside)

        return button
    }()

    // 내용 텍스트뷰
    lazy var postTextView: UITextView = {
        let postTextView = UITextView()
        postTextView.translatesAutoresizingMaskIntoConstraints = false

        postTextView.text = "문구 입력..."
        postTextView.font = UIFont.systemFont(ofSize: 17)
        postTextView.layer.borderColor = UIColor.lightGray.cgColor
        postTextView.layer.borderWidth = 1.0
        postTextView.layer.cornerRadius = 15.0
        postTextView.textContainerInset = UIEdgeInsets(top: 12, left: 5, bottom: 12, right: 5)
        postTextView.textColor = .placeholderText

        postTextView.delegate = self

        return postTextView
    }()

    // 로딩화면
//    private lazy var loadingScreenView: UIView = {
//        // 로딩 화면 뷰 생성
//        let loadingView = UIView(frame: view.bounds)
//        loadingView.backgroundColor = .white
//        loadingView.alpha = 0.5
//        loadingView.isHidden = true // 초기 상태는 숨김으로 설정
//
//        let activityIndicator = UIActivityIndicatorView(style: .medium)
//
//        activityIndicator.center = loadingView.center
//        activityIndicator.startAnimating()
//        loadingView.addSubview(activityIndicator)
//        view.addSubview(loadingView)
//
//        return loadingView
//    }()

    // MARK: - 스택뷰

    // 이미지 추가 스택뷰
    private lazy var imageAddStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postProfileImageView, postshadowView, imageAddButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupViews()
        setUpConstraints()
    }

    //
    private func setupViews() {
        view.addSubview(postTextView)
        view.addSubview(imageAddStackView)
        postshadowView.addSubview(postProfileImageView)
        view.addSubview(postshadowView)
    }

    // 상단바 아이템
    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(postDoneButtonTap))
        rightButton.tintColor = UIColor.label
        navigationItem.rightBarButtonItem = rightButton

        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.label,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        navigationItem.title = "게시글 추가"
    }

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // 그림자 뷰
            postshadowView.topAnchor.constraint(equalTo: imageAddStackView.topAnchor, constant: 30),
            postshadowView.centerXAnchor.constraint(equalTo: imageAddStackView.centerXAnchor),
            postshadowView.widthAnchor.constraint(equalToConstant: 120),
            postshadowView.heightAnchor.constraint(equalToConstant: 120),

            // 프로필이미지 뷰
            postProfileImageView.topAnchor.constraint(equalTo: postshadowView.topAnchor),
            postProfileImageView.leadingAnchor.constraint(equalTo: postshadowView.leadingAnchor),
            postProfileImageView.trailingAnchor.constraint(equalTo: postshadowView.trailingAnchor),
            postProfileImageView.bottomAnchor.constraint(equalTo: postshadowView.bottomAnchor),

            // 이미지 추가 버튼
            imageAddButton.topAnchor.constraint(equalTo: postshadowView.bottomAnchor, constant: 20),
            imageAddButton.centerXAnchor.constraint(equalTo: postshadowView.centerXAnchor),
            imageAddButton.widthAnchor.constraint(equalToConstant: 40),
            imageAddButton.heightAnchor.constraint(equalToConstant: 20),
            imageAddButton.leadingAnchor.constraint(equalTo: imageAddStackView.leadingAnchor, constant: 120),
            imageAddButton.trailingAnchor.constraint(equalTo: imageAddStackView.trailingAnchor, constant: -120),

            // 이미지 추가 스택뷰
            imageAddStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageAddStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageAddStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            imageAddStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            imageAddStackView.heightAnchor.constraint(equalToConstant: 200),

            // 글 입력 텍스트뷰
            postTextView.topAnchor.constraint(equalTo: imageAddStackView.bottomAnchor, constant: 60),
            postTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            postTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            postTextView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }

    @objc func postDoneButtonTap() {
        loadingScreenView()
        if let selectedImage = postProfileImageView.image {
            self.selectedImage = selectedImage
            delegate?.didCompletePost(with: selectedImage)
        }
        // 로딩 화면 보여주기
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { // 0.8초 후 실행되는 클로저 추가
            self.dismissLoadingScreen()
            self.dismiss(animated: true) // 현재 ViewController 닫기
        }
    }

    // 로딩화면
    private func loadingScreenView() {
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

    // 프로필 이미지 눌렀을때
    @objc func postProfileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        present(imagePickerController, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let postSelectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            postProfileImageView.image = postSelectedImage
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func imageAddButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        present(imagePickerController, animated: true)
    }

    // 로딩화면 사라짐
    private func dismissLoadingScreen() {
        guard let loadingView = loadingView else { return }
        DispatchQueue.main.async {
            loadingView.removeFromSuperview()
            self.loadingView = nil
        }
    }

    // 빈화면 터치시 키보드 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension PostAddViewController: UIImagePickerControllerDelegate {
    //
}

extension PostAddViewController: UINavigationControllerDelegate {
    //
}

extension PostAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard postTextView.textColor == .placeholderText else { return }
        postTextView.textColor = .label
        postTextView.text = nil
        postTextView.font = UIFont.systemFont(ofSize: 16)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if postTextView.text.isEmpty {
            postTextView.text = "문구 입력..."
            postTextView.textColor = .placeholderText
            postTextView.font = UIFont.systemFont(ofSize: 16)
        }
    }
}
