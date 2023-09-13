// 프로필 페이지

import UIKit

class ProfileDesignViewController: UIViewController {
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

    // 게시 숫자 라벨
    private lazy var postNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "0"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)

        return label
    }()

    // 게시 라벨
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "게시"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)

        return label
    }()

    // 팔로우 숫자 라벨
    private lazy var followNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "0"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)

        return label
    }()

    // 팔로우 라벨
    private lazy var followLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "팔로우"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)

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
        label.font = UIFont.systemFont(ofSize: 12)

        return label
    }()

    // 이름 라벨
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "성준"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)

        return label
    }()

    // 소개 라벨
    private lazy var introduceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "소개"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)

        return label
    }()

    // 링크 텍스트뷰
    private lazy var linkTextView: LinkTextView = {
        let textView = LinkTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false

        // "내 인스타 링크"라는 문자열을 생성하고, 이 문자열에 하이퍼링크 속성을 추가합니다.
        let attributedString = NSMutableAttributedString(string: "instagram link")

        if let url = URL(string: "https://instagram.com/s_____j05?igshid=NGVhN2U2NjQ0Yg==") {
            attributedString.setAttributes([.link: url], range: NSMakeRange(0, attributedString.length))

            textView.attributedText = attributedString
            textView.linkTextAttributes = [
                .foregroundColor: UIColor.systemBlue,
                .font: UIFont.systemFont(ofSize: 13),
            ]

            // 추가 설정
            textView.isEditable = false
            textView.isUserInteractionEnabled = true

            return textView
        } else {
            fatalError("URL 없음")
        }
    }()

    // MARK: - 스택뷰

    // 1. 프로필 이미지
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shadowView, numberStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 50

        return stackView
    }()

    // 2. 게시, 팔로우, 팔로잉 스택뷰
    private lazy var numberStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postStackView, followStackView, followingStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 50

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

    // 게시 스택뷰
    private lazy var postStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postNumberLabel, postLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 1

        return stackView
    }()

    // 팔로우 스택뷰
    private lazy var followStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followNumberLabel, followLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 1

        return stackView
    }()

    // 팔로잉 스택뷰
    private lazy var followingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followingNumberLabel, followingLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 1

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
            // 그림자 뷰
            shadowView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            shadowView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            shadowView.widthAnchor.constraint(equalToConstant: 100),
            shadowView.heightAnchor.constraint(equalToConstant: 100),

            // 프로필이미지 뷰
            profileImageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),

            // 프로필 스택 뷰
            numberStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),

            // 소개 스택 뷰
            introduceStackView.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 20),
            introduceStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            introduceStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            introduceStackView.heightAnchor.constraint(equalToConstant: 80),

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
