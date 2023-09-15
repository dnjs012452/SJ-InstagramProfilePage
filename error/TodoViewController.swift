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
        button.tintColor = .black
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 25
        button.clipsToBounds = false

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 4.0

        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        addTodoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
        addTodoTableView.dataSource = self
        addTodoTableView.delegate = self

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
            addbutton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -35),
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
        presentSectionSelectionAlert()
    }

    func presentSectionSelectionAlert() {
        let alertController = UIAlertController(title: "section menu", message: nil, preferredStyle: .actionSheet)

        // 선택 버튼
        let selectAction = UIAlertAction(title: "섹션 선택", style: .default) { [weak self] _ in
            self?.selectSection()
        }

        // 추가 버튼
        let addAction = UIAlertAction(title: "섹션 추가", style: .default) { [weak self] _ in
            self?.addSection()
        }

        // 삭제 버튼
        let deleteAction = UIAlertAction(title: "섹션 삭제", style: .destructive) { [weak self] _ in
            self?.deleteSection()
        }

        // 취소 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        // 알럿 addAction
        alertController.addAction(selectAction)
        alertController.addAction(addAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    // 섹션 선택 알럿창
    func selectSection() {
        let alert = UIAlertController(title: "섹션 선택", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        let pickerView = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        alert.view.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self

        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            print("선택완료")
        })

        present(alert, animated: true, completion: nil)
    }

    // 섹션 추가 알럿창
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

                self?.showToast(message: "섹션이 추가되었습니다.")
            }
        }

        alertContoller.addAction(saveAction)

        present(alertContoller, animated: true, completion: nil)
    }

    // 섹션 삭제 알럿창
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

                    self.showToast(message: "섹션이 삭제되었습니다.")
                }
            })
        }

        actions.append(UIAlertAction(title: "취소", style: .cancel))
//        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
//            // 여기에 확인 버튼이 눌렸을 때의 동작을 작성.
//        }
        let alert = UIAlertController(
            title: "섹션 삭제",
            message: "삭제할 섹션을 선택해주세요.",
            preferredStyle: UIAlertController.Style.actionSheet
        )

        for action: UIAlertAction in actions { alert.addAction(action) }

        // alert.addAction(confirmAction) // 확인 액션 추가
        present(alert, animated: true, completion: nil)
    }

    // 불투명 알럿
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width / 2 - 120, y: 110, width: 240, height: 30))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 0.5
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { isCompleted in
            if isCompleted {
                toastLabel.removeFromSuperview()
            }
        })
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

extension TodoViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView)->Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)->String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)->CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int)->CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int)->UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let label = UILabel()
        label.text = sections[section]
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.frame = CGRect(x: 15, y: 5, width: tableView.bounds.size.width - 30, height: 25)

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

extension TodoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView)->Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        return sections.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)->String? {
        return sections[row]
    }
}
