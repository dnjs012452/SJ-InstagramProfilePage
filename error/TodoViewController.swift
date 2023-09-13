// 할일 확인하기 페이지

import UIKit

class TodoViewController: UIViewController {
    private lazy var addTodoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()

    private lazy var addbutton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        addTodoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
        addTodoTableView.dataSource = self

        setupNavigationBar()
        setupViews()
        setUpConstraints()
    }

    // 화면에 보여지게 하는 부분
    private func setupViews() {
        view.addSubview(addTodoTableView)
        view.addSubview(addbutton)
    }

    // 상단 바
    private func setupNavigationBar() {
        // edit 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.black

        // 섹션 선택 버튼
        let selectSectionButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(selectSectionButtonTapped))

        navigationItem.rightBarButtonItems = [selectSectionButton, navigationItem.rightBarButtonItem].compactMap { $0 }
    }

    // 상단 오른쪽 더보기 버튼
//    @objc func moreButtonTapped() {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//
//        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
//            self?.editButtonTapped()
//        }
//
//        let selectSectionAction = UIAlertAction(title: "Select Section", style: .default) { [weak self] _ in
//            self?.selectSectionButtonTapped()
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        alertController.addAction(editAction)
//        alertController.addAction(selectSectionAction)
//        alertController.addAction(cancelAction)
//
//        if let popoverController = alertController.popoverPresentationController {
//            popoverController.barButtonItem = navigationItem.rightBarButtonItem
//            popoverController.permittedArrowDirections = [.down]
//            popoverController.sourceView = view // 이 부분은 필요에 따라 변경 가능합니다.
//            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
//        }
//        present(alertController, animated: true)
//    }

    // MARK: - 레이아웃

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // 테이블 뷰
            addTodoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addTodoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addTodoTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addTodoTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            // add 버튼
            addbutton.widthAnchor.constraint(equalToConstant: 50),
            addbutton.heightAnchor.constraint(equalToConstant: 50),
            addbutton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -45),
            addbutton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),
        ])
    }

    // MARK: - 기능, 액션

    // 상단 edit 버튼
    @objc func editButtonTapped() {
        if addTodoTableView.isEditing {
            addTodoTableView.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem?.title = "Edit"
        } else {
            addTodoTableView.setEditing(true, animated: true)
            navigationItem.leftBarButtonItem?.title = "Done"
        }
    }

    // 상단 섹션 버튼
    @objc func selectSectionButtonTapped() {
        let alertController = UIAlertController(title: "Select Section", message: nil, preferredStyle: .alert)
    }

    // 새로운 할 일 아이템 추가하는 화면으로 이동
    @objc func addButtonTapped() {
        let vc = AddViewController()

        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true)
    }
}

// MARK: TodoViewController 클래스 끝

// MARK: - 클래스로 셀 생성

class TodoTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        // 여기에 셀 내부 뷰의 설정을 작성합니다.
    }
}

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 여기에서 각 섹션별 로우(셀) 개수를 반환합니다.
        return 0 // 예시로 0을 반환하였지만 실제 개발 시에는 데이터에 맞게 변경해야 합니다.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell

        // 여기에서 각 셀의 내용을 설정합니다.

        return cell
    }
}
