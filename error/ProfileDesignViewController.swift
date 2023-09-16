// 프로필 페이지

import UIKit

class ProfileDesignViewController: UIViewController {
    let userDefaultsKey = "profileImages"

    var images: [UIImage] = []

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
        view.layer.shadowRadius = 5
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

        label.text = "코딩으아아아아아 ㅈ빡치네ㄴ 그만 괴롭혀"
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

    // MARK: - 게시글/태그된 게시글 선택 버튼

    // 게시글 버튼
    private lazy var postsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        if let downArrowImage = UIImage(named: "grid") {
            let downArrowImageSize = CGSize(width: 30, height: 30)
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
        button.backgroundColor = UIColor.systemBackground
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5

        // 기능 추가
        button.addTarget(self, action: #selector(postsButtonTapped), for: .touchUpInside)

        return button
    }()

    // 태그된 게시글 버튼
    private lazy var taggedPostsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        if let downArrowImage = UIImage(named: "taggedImage") {
            let downArrowImageSize = CGSize(width: 25, height: 25)
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
        button.backgroundColor = UIColor.systemBackground
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5

        // 기능추가
        button.addTarget(self, action: #selector(taggedPostsButtonTapped), for: .touchUpInside)

        return button
    }()

    // 게시글/태그된 게시글 선택버튼 아래 선 - View
    private lazy var highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .black

        return view
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

    // 5. 게시글/태그된 게시글 버튼 스택뷰
    private lazy var selectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postsButton, taggedPostsButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.spacing = 5

        return stackView
    }()

    // MARK: - 게시글/태그된 게시글 컬렉션뷰

    // 게시글 컬렉션뷰
    private lazy var postsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width - 2) / 3, height: (view.frame.size.width - 2) / 3)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white

        // 셀 등록
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "postCell")

        // 데이터 소스 및 델리게이트 설정
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    // 태그된 게시글 컬렉션뷰
    private lazy var taggedPostsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width - 2) / 3, height: (view.frame.size.width - 2) / 3)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white

        // 셀 등록
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "postCell")

        // 데이터 소스 및 델리게이트 설정
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // 이전에 저장된 이미지를 불러옴
        if let savedImagesData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedImages = NSKeyedUnarchiver.unarchiveObject(with: savedImagesData) as? [UIImage]
        {
            images = savedImages
        }

        profileSetupNavigationBar()
        setupViews()
        setUpConstraints()

        postsCollectionView.isHidden = false
        taggedPostsCollectionView.isHidden = true
        postsCollectionView.dataSource = self
    }

    // 이미지를 UserDefaults에 저장하는 함수
    func saveImagesToUserDefaults() {
        let imagesData = NSKeyedArchiver.archivedData(withRootObject: images)
        UserDefaults.standard.set(imagesData, forKey: userDefaultsKey)
    }

    // 이미지가 추가되거나 삭제될 때 호출되는 함수
    func updateImages() {
        postsCollectionView.reloadData()
        // 이미지가 업데이트 될 때마다 UserDefaults에 저장
        saveImagesToUserDefaults()
    }

    // MARK: - 화면 보여지게 하는 곳

    private func setupViews() {
        shadowView.addSubview(profileImageView)
        view.addSubview(shadowView)
        view.addSubview(selectionStackView)
        view.addSubview(buttonStackView)
        view.addSubview(introduceStackView)
        view.addSubview(numberStackView)
        view.addSubview(profileStackView)
        view.addSubview(postsCollectionView)
        view.addSubview(taggedPostsCollectionView)
        selectionStackView.addSubview(highlightView)
    }

    // MARK: - 상단바 아이템

    // 상단 바
    private func profileSetupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.black
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()

        navBarAppearance.backgroundColor = .white // #F8F0E5
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        // 타이틀
        let titleLabel = UILabel()
        titleLabel.text = "s_____j05"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel

        // 게시글 추가 버튼
        if let plusPostImage = UIImage(named: "pluspost") {
            let pluspostButtonSize = CGSize(width: 22, height: 22)
            UIGraphicsBeginImageContextWithOptions(pluspostButtonSize, false, UIScreen.main.scale)
            plusPostImage.draw(in: CGRect(origin: .zero, size: pluspostButtonSize))

            if let resizedPlusImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()

                let addPostButton = UIBarButtonItem(image: resizedPlusImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addPostButtonTapped))
                addPostButton.imageInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)

                navigationItem.rightBarButtonItem = addPostButton
            }

            UIGraphicsEndImageContext()
        }

        // 메뉴 버튼
        if let menuImage = UIImage(named: "menuImage") {
            let menuImageSize = CGSize(width: 37, height: 37)
            UIGraphicsBeginImageContextWithOptions(menuImageSize, false, UIScreen.main.scale)
            menuImage.draw(in: CGRect(origin: .zero, size: menuImageSize))

            if let resizedMenuImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()

                let selectSectionButton = UIBarButtonItem(image: resizedMenuImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuButtonTapped))
                selectSectionButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
            buttonStackView.heightAnchor.constraint(equalToConstant: 26),

            // 팔로우 버튼
            followButton.widthAnchor.constraint(equalToConstant: 150),
            followButton.heightAnchor.constraint(equalToConstant: 30),

            // 메세지 버튼
            messageButton.widthAnchor.constraint(equalToConstant: 150),
            messageButton.heightAnchor.constraint(equalToConstant: 30),

            // 아래화살표 버튼
            arrowButton.widthAnchor.constraint(equalToConstant: 26),
            arrowButton.heightAnchor.constraint(equalToConstant: 26),

            // 선택버튼 스택뷰
            selectionStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            selectionStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            selectionStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            selectionStackView.heightAnchor.constraint(equalToConstant: 40),

            // 게시글 버튼
            postsButton.widthAnchor.constraint(equalTo: selectionStackView.widthAnchor, multiplier: 0.5, constant: -2.5),

            // 태그된 게시글 버튼
            taggedPostsButton.widthAnchor.constraint(equalTo: selectionStackView.widthAnchor, multiplier: 0.5, constant: -2.5),

            // 게시글 콜렉션 뷰
            postsCollectionView.topAnchor.constraint(equalTo: selectionStackView.bottomAnchor, constant: 10),
            postsCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            postsCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            postsCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            // 태그된 게시글 콜렉션뷰
            taggedPostsCollectionView.topAnchor.constraint(equalTo: selectionStackView.bottomAnchor, constant: 10),
            taggedPostsCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            taggedPostsCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            taggedPostsCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            // 하이라이트뷰 (게시글/태그된 게시글 선택버튼 아래 선)
            highlightView.bottomAnchor.constraint(equalTo: selectionStackView.bottomAnchor),
            highlightView.heightAnchor.constraint(equalToConstant: 1),
            highlightView.widthAnchor.constraint(equalTo: postsButton.widthAnchor),
            highlightView.centerXAnchor.constraint(equalTo: postsButton.centerXAnchor),
        ])
    }

    // MARK: - 기능, 액션

    // 상단바 게시글 추가 버튼
    @objc func addPostButtonTapped() {
        let vc = PostAddViewController()
        vc.delegate = self // delegate 설정

        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true)
    }

    // 상단바 메뉴 버튼 눌렀을때
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

    // 게시글 버튼 눌렀을때
    @objc func postsButtonTapped() {
        postsCollectionView.isHidden = false
        taggedPostsCollectionView.isHidden = true

        // 각 버튼을 클릭할 때마다 highlightView의 중심점 x 좌표가 해당 버튼의 중심점 x 좌표로 이동하도록 애니메이션을 추가.
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.highlightView.center.x = self.postsButton.center.x
        }
    }

    // 태그된 게시글 버튼 눌렀을때
    @objc func taggedPostsButtonTapped() {
        postsCollectionView.isHidden = true
        taggedPostsCollectionView.isHidden = false

        // 각 버튼을 클릭할 때마다 highlightView의 중심점 x 좌표가 해당 버튼의 중심점 x 좌표로 이동하도록 애니메이션을 추가.
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.highlightView.center.x = self.taggedPostsButton.center.x
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

extension ProfileDesignViewController: UICollectionViewDelegate {
    //
}

extension ProfileDesignViewController: UICollectionViewDataSource {
    func numberOfSections(incollectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == taggedPostsCollectionView {
            return 0 // taggedPostsCollectionView에는 아이템이 없습니다.
        }
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath)

        if collectionView == postsCollectionView { // postsCollectionView인 경우만 이미지를 설정합니다.
            if let imageView = cell.contentView.subviews.first as? UIImageView {
                imageView.image = images[indexPath.item]
            } else {
                let imageView = UIImageView(frame: cell.bounds)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = images[indexPath.item]
                cell.contentView.addSubview(imageView)
            }
        }

        return cell
    }
}

extension ProfileDesignViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == postsCollectionView {
            cell.backgroundColor = .systemGray5
        } else if collectionView == taggedPostsCollectionView {
            cell.backgroundColor = .systemGray3
        }
    }
}

extension ProfileDesignViewController: PostAddDelegate {
    func didCompletePost(with image: UIImage) {
        images.insert(image, at: 0) // 이미지를 배열의 맨 앞에 추가합니다.
        saveImagesToUserDefaults()
        DispatchQueue.main.async { [weak self] in
            self?.postsCollectionView.reloadData()
        }

        dismiss(animated: true, completion: nil) // 모달 창 닫기 (선택 사항)
    }
}

// 링크 텍스트뷰 패딩 값 없애기
class LinkTextView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
    }
}
