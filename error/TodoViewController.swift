// 할일 확인하기 페이지

import UIKit

class TodoViewController: UIViewController {
    // 섹션 이름
    var sections = ["월요일", "화요일"]

    // 테이블 뷰
    private lazy var addTodoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()

    // 추가 버튼
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

        // UserDefaults에서 전체 할 일 목록을 불러옴 (섹션 이름들)
        if let data = UserDefaults.standard.data(forKey: "sections"),
           let savedSections = try? JSONDecoder().decode([String].self, from: data)
        {
            sections = savedSections
        } else {
            sections = ["월요일", "화요일"]
            if let data = try? JSONEncoder().encode(sections) {
                UserDefaults.standard.set(data, forKey: "sections")
            }
        }
    }

    // 화면에 보여지게 하는 부분
    private func setupViews() {
        view.addSubview(addTodoTableView)
        view.addSubview(addbutton)
    }

    // MARK: - 상단바 아이템

    // 상단 바
    private func setupNavigationBar() {
        // edit 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.black

        if let menuImage = UIImage(named: "menuImage") {
            let menuImageSize = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContextWithOptions(menuImageSize, false, UIScreen.main.scale)
            menuImage.draw(in: CGRect(origin: .zero, size: menuImageSize))

            if let resizedMenuImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()

                // 섹션 버튼
                let sectionButton = UIBarButtonItem(image: resizedMenuImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(sectionButtonTapped))
                navigationItem.rightBarButtonItems = [sectionButton, navigationItem.rightBarButtonItem].compactMap { $0 }
            }

            UIGraphicsEndImageContext()
        }
    }

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

    // 상단 edit 버튼 눌렀을때
    @objc func editButtonTapped() {
        if addTodoTableView.isEditing {
            addTodoTableView.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem?.title = "Edit"
        } else {
            addTodoTableView.setEditing(true, animated: true)
            navigationItem.leftBarButtonItem?.title = "Done"
        }
    }

    // 상단 섹션 버튼 눌렀을때
    @objc func sectionButtonTapped() {
        let alertController = UIAlertController(title: "섹션 선택", message: nil, preferredStyle: .alert)

        // 선택 버튼
        for section in sections {
            let selectAction = UIAlertAction(title: "\(section)", style: .default) { _ in
                // 여기에 선택한 섹션에 대한 처리를 작성합니다.
            }
            alertController.addAction(selectAction)
        }

        // 추가 버튼
        let addAction = UIAlertAction(title: "섹션 추가", style: .default) { [weak self] _ in
            self?.addSection()
        }

        alertController.addAction(addAction)

        // 삭제버튼
        let deleteAction = UIAlertAction(title: "섹션 삭제", style: .destructive) { [weak self] _ in
            self?.deleteSection()
        }

        alertController.addAction(deleteAction)

        // 취소버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    func addSection() {
        let alertContoller = UIAlertController(title: "새로운 섹션", message: "섹션 이름을 작성해주세요.", preferredStyle: .alert)

        alertContoller.addTextField()

        let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self, weak alertContoller] _ in

            guard let textField = alertContoller?.textFields?[0], let newSectionName = textField.text,!newSectionName.isEmpty else {
                return
            }

            self?.sections.append(newSectionName)

            if let sections = self?.sections, let data = try? JSONEncoder().encode(sections) {
                UserDefaults.standard.set(data, forKey: "sections")
            }

            DispatchQueue.main.async {
                self?.addTodoTableView.reloadData()
            }
        }

        alertContoller.addAction(saveAction)

        present(alertContoller, animated: true)
    }

    func deleteSection() {
        var actions: [UIAlertAction] = []

        for (index, name) in sections.enumerated() {
            actions.append(UIAlertAction(title: name, style: .destructive) { [weak self] _ in

                guard let self = self else { return }
                guard index < self.sections.count else {
                    return
                }

                self.sections.remove(at: index)

                if let data = try? JSONEncoder().encode(self.sections) {
                    UserDefaults.standard.set(data, forKey: "sections")
                }

                DispatchQueue.main.async {
                    self.addTodoTableView.reloadData()
                }
            })
        }

        actions.append(UIAlertAction(title: "취소", style: .cancel))

        let actionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertController.Style.actionSheet
        )

        for action: UIAlertAction in actions { actionSheet.addAction(action) }

        present(actionSheet, animated: true, completion: nil)
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

// MARK: - 헤더, 푸터

extension TodoViewController {
    func numberOfSections(in tableView: UITableView)->Int {
        return sections.count
    }

    func tableView(_tableView: UITableView, titleForHeaderInSection section: Int)->String? {
        return sections[section]
    }

    func tableView(_tableView: UITableView, heightForHeaderInSection section: Int)->CGFloat {
        return 50
    }

    func tableView(_tableView: UITableView, heightForFooterInSection section: Int)->CGFloat {
        return 0
    }

    func tableView(_tableView: UITableView, viewForHeaderInSection section: Int)->UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let label = UILabel()
        label.text = sections[section]
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.frame = CGRect(x: 15, y: 5, width: _tableView.bounds.size.width - 30, height: 25)

        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int)->UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .white

        return footerView
    }
}

// MARK: - UITableViewDataSource

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int {
        // 여기에서 각 섹션별 로우(셀) 개수를 반환합니다.
        return 0 // 예시로 0을 반환하였지만 실제 개발 시에는 데이터에 맞게 변경해야 합니다.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell

        // 여기에서 각 셀의 내용을 설정합니다.

        return cell
    }
}
