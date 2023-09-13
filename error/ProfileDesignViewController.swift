// 프로필 페이지

import UIKit

class ProfileDesignViewController: UIViewController {
    // MARK: - 프로필 이미지 뷰, 그림자 뷰

    // 프로필 이미지뷰
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true

        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "default_profile")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 50

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }()

    // 그림자 뷰
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 7
        view.layer.cornerRadius = 50

        return view
    }()

    // MARK: - 게시글, 팔로우, 팔로잉

    // 게시글 숫자 라벨
    private lazy var postNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "0"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)

        return label
    }()

    // 게시글 라벨
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "게시"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)

        return label
    }()

    // 팔로우 숫자 라벨
    private lazy var followerNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "0"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)

        return label
    }()

    // 팔로워 라벨
    private lazy var followerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "팔로워"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)

        return label
    }()

    // 팔로잉 숫자 라벨
    private lazy var followingNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "0"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)

        return label
    }()

    // 팔로잉 라벨
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "팔로잉"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)

        return label
    }()

    // MARK: - 이름, 소개, 링크

    // 이름 라벨
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "성준"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)

        return label
    }()

    // 소개 라벨
    private lazy var introduceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "소개 텍스트"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)

        return label
    }()

    // 링크 텍스트뷰
    private lazy var linkTextView: LinkTextView = {
        let textView = LinkTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false

        // 링크 추가
        let attributedString = NSMutableAttributedString(string: "My Instagram Link")

        if let url = URL(string: "https://instagram.com/s_____j05?igshid=NGVhN2U2NjQ0Yg==") {
            attributedString.setAttributes([.link: url], range: NSMakeRange(0, attributedString.length))

            textView.attributedText = attributedString
            textView.linkTextAttributes = [
                .foregroundColor: UIColor.systemBlue,
                .font: UIFont.systemFont(ofSize: 14),
            ]

            // 추가 설정
            textView.isEditable = false
            textView.isUserInteractionEnabled = true

            return textView
        } else {
            fatalError("URL 없음")
        }
    }()

    // MARK: - 팔로우, 메세지, 아래 화살표 버튼

    // 팔로우 버튼
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitleColor(.black, for: .normal)
        button.setTitle("팔로우", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 15)

        // 버튼 디자인
        button.backgroundColor = UIColor.systemGray5
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)

        return button
    }()

    // 메세지 버튼
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitleColor(.black, for: .normal)
        button.setTitle("메세지", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 15)

        // 버튼 디자인
        button.backgroundColor = UIColor.systemGray5
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)

        return button
    }()

    // 아래 화살표 버튼
    private lazy var arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        if let downArrowImage = UIImage(named: "downArrow") {
            let downArrowImageSize = CGSize(width: 17, height: 17)
            UIGraphicsBeginImageContextWithOptions(downArrowImageSize, false, UIScreen.main.scale)
            downArrowImage.draw(in: CGRect(origin: .zero, size: downArrowImageSize))

            if let resizedDownArrowImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                button.setImage(resizedDownArrowImage.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                UIGraphicsEndImageContext()
            }
        }

        // 버튼 디자인
        button.backgroundColor = UIColor.systemGray5
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(arrowButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - 스택뷰

    // 1. 프로필 이미지, 게시글, 팔로워, 팔로잉 스택뷰
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shadowView, numberStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 50

        return stackView
    }()

    // 게시글 스택뷰
    private lazy var postStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postNumberLabel, postLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 2

        return stackView
    }()

    // 팔로워 스택뷰
    private lazy var followStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followerNumberLabel, followerLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 2

        return stackView
    }()

    // 팔로잉 스택뷰
    private lazy var followingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followingNumberLabel, followingLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 2

        return stackView
    }()

    // 2. 게시글, 팔로워, 팔로잉 스택뷰
    private lazy var numberStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postStackView, followStackView, followingStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 45

        return stackView
    }()

    // 3. 이름, 소개, 링크 스택뷰
    private lazy var introduceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, introduceLabel, linkTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 5

        return stackView
    }()

    // 4. 팔로우 , 메세지, 아래화살표 버튼 스택뷰
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followButton, messageButton, arrowButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 7

        return stackView
    }()

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupViews()
        setUpConstraints()
    }

    // MARK: - 화면 보여지게 하는 곳

    private func setupViews() {
        shadowView.addSubview(profileImageView)
        view.addSubview(shadowView)

        view.addSubview(buttonStackView)
        view.addSubview(introduceStackView)
        view.addSubview(numberStackView)
        view.addSubview(profileStackView)
    }

    // 상단 바
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.black

        // 타이틀
        let titleLabel = UILabel()
        titleLabel.text = "s_____j05"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel

        // 메뉴
        if let menuImage = UIImage(named: "menuImage") {
            let menuImageSize = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContextWithOptions(menuImageSize, false, UIScreen.main.scale)
            menuImage.draw(in: CGRect(origin: .zero, size: menuImageSize))

            if let resizedMenuImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()

                let selectSectionButton = UIBarButtonItem(image: resizedMenuImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuButtonTapped))
                navigationItem.rightBarButtonItems = [selectSectionButton, navigationItem.rightBarButtonItem].compactMap { $0 }
            }

            UIGraphicsEndImageContext()
        }
    }

    // MARK: - 레이아웃

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // 프로필 스택뷰 (프로필 이미지, 게시글, 팔로워, 팔로잉)
            profileStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            profileStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            profileStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            profileStackView.heightAnchor.constraint(equalToConstant: 100),

            // 그림자 뷰
            shadowView.topAnchor.constraint(equalTo: profileStackView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: profileStackView.leadingAnchor),
            shadowView.widthAnchor.constraint(equalToConstant: 100),
            shadowView.heightAnchor.constraint(equalToConstant: 100),

            // 프로필이미지 뷰
            profileImageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),

            // 프로필 스택 뷰 (게시글, 팔로워, 팔로잉)
            numberStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),

            // 소개 스택 뷰 (이름, 소개, 링크)
            introduceStackView.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 20),
            introduceStackView.leadingAnchor.constraint(equalTo: profileStackView.leadingAnchor, constant: 5),
            introduceStackView.trailingAnchor.constraint(equalTo: profileStackView.trailingAnchor),
            introduceStackView.heightAnchor.constraint(equalToConstant: 70),

            // 버튼 스택 뷰
            buttonStackView.topAnchor.constraint(equalTo: introduceStackView.bottomAnchor, constant: 10),
            buttonStackView.leadingAnchor.constraint(equalTo: introduceStackView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: introduceStackView.trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 30),

            // 팔로우 버튼
            followButton.widthAnchor.constraint(equalToConstant: 150),
            followButton.heightAnchor.constraint(equalToConstant: 30),

            // 메세지 버튼
            messageButton.widthAnchor.constraint(equalToConstant: 150),
            messageButton.heightAnchor.constraint(equalToConstant: 30),

            // 아래화살표 버튼
            arrowButton.widthAnchor.constraint(equalToConstant: 30),
            arrowButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    // MARK: - 기능, 액션

    // 메뉴 버튼 눌렀을때
    @objc func menuButtonTapped() {
        let vc = MenuViewController()

        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true)
    }

    // 프로필 이미지 눌렀을때
    @objc func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        present(imagePickerController, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }

    // 팔로우 버튼 눌렀을때
    @objc func followButtonTapped() {
        //
    }

    @objc func messageButtonTapped() {
        //
    }

    @objc func arrowButtonTapped() {
        //
    }
}

// MARK: -

extension ProfileDesignViewController: UIImagePickerControllerDelegate {
    //
}

extension ProfileDesignViewController: UINavigationControllerDelegate {
    //
}

// 링크 텍스트뷰 패딩 값 없애기
class LinkTextView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
    }
}
