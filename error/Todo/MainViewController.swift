// 메인페이지

import UIKit

class MainViewController: UIViewController {
    // image touch 라벨
    private lazy var imagetouchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Image Touch!"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    // cat 이미지뷰
    lazy var catImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        // 이미지 탭
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTapGesture)
        
        return imageView
    }()
    
    // 할일확인 하기 버튼
    private lazy var todoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("할일 확인하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        
//        button.backgroundColor = UIColor.systemGray5
//        button.layer.borderColor = UIColor.systemBackground.cgColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(todoGoButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // 완료된일 보기 버튼
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.black, for: .normal)
        button.setTitle("완료된일 보기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        
//        button.backgroundColor = UIColor.systemGray5
//        button.layer.borderColor = UIColor.systemBackground.cgColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(doneGoButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var profilePageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.black, for: .normal)
        button.setTitle("프로필 페이지", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        
//        button.backgroundColor = UIColor.systemGray5
//        button.layer.borderColor = UIColor.systemBackground.cgColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(profilePageButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // 버튼 스택뷰
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todoButton, doneButton, profilePageButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 25
        
        return stackView
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo"
        view.backgroundColor = .systemBackground
//        UIColor(red: 248/255, green: 240/255, blue: 229/255, alpha: 1) // #F8F0E5
        
        mainSetupNavigationBar()
        setUpViews()
        fetchCatImage()
        setUpConstraints()
    }
    
    // 화면에 나타나는 곳
    private func setUpViews() {
        view.addSubview(imagetouchLabel)
        view.addSubview(catImageView)
        view.addSubview(todoButton)
        view.addSubview(doneButton)
        view.addSubview(buttonStackView)
    }
    
    // 상단 바
    private func mainSetupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.black
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundColor = .systemBackground
//        UIColor(red: 248/255, green: 240/255, blue: 229/255, alpha: 1) // #F8F0E5
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        // 타이틀
        let titleLabel = UILabel()
        titleLabel.text = "Todo"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }

    // MARK: - 레이아웃
    
    private func setUpConstraints() {
        var safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // imagetouch 라벨
            imagetouchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagetouchLabel.bottomAnchor.constraint(equalTo: catImageView.topAnchor, constant: -15),
            
            catImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            catImageView.widthAnchor.constraint(equalToConstant: 260),
            catImageView.heightAnchor.constraint(equalToConstant: 200),
            catImageView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -60),
            
            // 할일 확인하기, 완료된일 보기 버튼 스택뷰
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
        ])
    }

    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        fetchCatImage()
    }

    private func fetchCatImage() {
        let urlAddress = "https://api.thecatapi.com/v1/images/search"
        guard let url = URL(string: urlAddress) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if error != nil {
                print("Failed fetching image:", error!)
                return
            }
            guard let data = data else { return }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
                    if let imgUrlString = jsonArray[0]["url"] as? String,
                       let imgUrl = URL(string: imgUrlString)
                    {
                        DispatchQueue.main.async {
                            self?.catImageView.load(url: imgUrl)
                        }
                    }
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }.resume()
    }

    @objc private func todoGoButtonTapped() {
        let todoViewController = TodoViewController()
        navigationController?.pushViewController(todoViewController, animated: true)
    }
    
    @objc private func doneGoButtonTapped() {
        let doneViewController = TodoDoneViewController()
        navigationController?.pushViewController(doneViewController, animated: true)
    }
   
    @objc private func profilePageButtonTapped() {
        let doneViewController = ProfileDesignViewController()
        navigationController?.pushViewController(doneViewController, animated: true)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
