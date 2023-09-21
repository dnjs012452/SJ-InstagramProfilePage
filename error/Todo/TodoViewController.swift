import CoreData
import UIKit

final class TodoViewController: UIViewController, AddTodoDelegate {
    var sections = [String]()
    var items: [[Task]] = [[], []]
    var doneItems: [Task] = []
    var selectedSectionIndex: Int?

    // 테이블뷰
    lazy var todoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.backgroundColor = .systemBackground
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        return tableView
    }()

    // 추가 버튼
    private lazy var addButton: UIButton = {
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

    // 상단바
    private func setupNavigationBar() {
        // 상단바 배경색 설정
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()

        navBarAppearance.backgroundColor = .systemBackground

        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        // edit 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.black

        // 섹션 선택 버튼
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // UserDefaults에서 전체 할 일 목록을 불러옴
        if let data = UserDefaults.standard.data(forKey: "items"),
           let savedItems = try? JSONDecoder().decode([[Task]].self, from: data)
        {
            items = savedItems
        }

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

        selectedSectionIndex = 0
        setupViews()
        setupNavigationBar()
        setUpConstraints()
    }

    // 화면에 보여지게 하는 부분
    private func setupViews() {
        view.addSubview(todoTableView)
        view.addSubview(addButton)
    }

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            todoTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            todoTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            todoTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            todoTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -35),
            addButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -15),
        ])
    }

    // MARK: - 기능 , 액션

    // 상단 edit 버튼 눌렀을때
    @objc func editButtonTapped() {
        if todoTableView.isEditing {
            todoTableView.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem?.title = "Edit"
        } else {
            todoTableView.setEditing(true, animated: true)
            navigationItem.leftBarButtonItem?.title = "Done"
        }
    }

    // 상단 섹션 버튼 눌렀을때
    @objc func sectionButtonTapped() {
        let alertController = UIAlertController(title: "section menu", message: nil, preferredStyle: .actionSheet)

        // 섹션 선택 알럿
        let selectAction = UIAlertAction(title: "섹션 선택", style: .default) { _ in

            self.selectSection()
            // 전체 섹션 목록과 아이템들을 UserDefaults에 저장합니다.
            if let data = try? JSONEncoder().encode(self.sections) {
                UserDefaults.standard.set(data, forKey: "sections")
            }
            if let data = try? JSONEncoder().encode(self.items) {
                UserDefaults.standard.set(data, forKey: "items")
            }
            self.todoTableView.reloadData()
        }

        // 섹션 추가 버튼
        let addAction = UIAlertAction(title: "섹션 추가", style: .default) { [weak self] _ in
            self?.addsection()
        }

        // 섹션 삭제 버튼
        let deleteAction = UIAlertAction(title: "섹션 삭제", style: .destructive) { [weak self] _ in
            self?.deleteSection()
        }

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
            self?.selectedSectionIndex = pickerView.selectedRow(inComponent: 0)
            let vc = TodoAddViewController()
            vc.selectedSectionIndex = self?.selectedSectionIndex
            vc.delegate = self
            let navController = UINavigationController(rootViewController: vc)
            self?.present(navController, animated: true)
            print("선택완료")
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true, completion: nil)
    }

    // 섹션 추가 알럿창
    func addsection() {
        let alertContoller = UIAlertController(title: "새로운 섹션", message: "섹션 이름을 작성해주세요.", preferredStyle: .alert)

        alertContoller.addTextField()

        let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self, weak alertContoller] _ in
            guard let textField = alertContoller?.textFields?[0], let newSectionName = textField.text, !newSectionName.isEmpty else {
                return
            }
            self?.sections.append(newSectionName)
            self?.items.append([])

            // 전체 섹션 목록과 아이템들을 UserDefaults에 저장합니다.
            if let sections = self?.sections, let sectionData = try? JSONEncoder().encode(sections) {
                UserDefaults.standard.set(sectionData, forKey: "sections")
            }
            if let itemData = try? JSONEncoder().encode(self?.items) {
                UserDefaults.standard.set(itemData, forKey: "items")
            }
            self?.todoTableView.reloadData()
            self?.showToast(message: "섹션이 추가되었습니다.")
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
                    self.todoTableView.reloadData()

                    self.showToast(message: "섹션이 삭제되었습니다.")
                }
            })
        }
        actions.append(UIAlertAction(title: "취소", style: .cancel))
        let alert = UIAlertController(
            title: "섹션 삭제",
            message: "삭제할 섹션을 선택해주세요.",
            preferredStyle: UIAlertController.Style.actionSheet
        )

        for action: UIAlertAction in actions { alert.addAction(action) }
        present(alert, animated: true, completion: nil)
    }

    // add 버튼 눌렀을때
    @objc func addButtonTapped() {
        let vc = TodoAddViewController()
        vc.selectedSectionIndex = selectedSectionIndex
        vc.delegate = self

        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true)
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

    // 사용자가 새로운 할 일을 추가했을 때 호출되는 메소드
    func didSaveNewTodo(todo: String, section: Int) {
        // 새로운 Task를 생성하고 해당 섹션의 배열에 추가
        let task = Task(title: todo)
        items[section].append(task)

        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: "items")
        }

        reloadDataOnMainThread()
    }

    private func reloadDataOnMainThread() {
        DispatchQueue.main.async { [weak self] in
            self?.todoTableView.reloadData()
        }
    }

    @objc func didSelectCell(at indexPath: IndexPath) {
        _ = items[indexPath.section][indexPath.row]
        let vc = TodoAddViewController()
        vc.selectedSectionIndex = selectedSectionIndex
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true)
    }
}

// 셀 관련
class TodoTableViewCell: UITableViewCell {
    let cellPadding: CGFloat = 5
    let cornerRadius: CGFloat = 10

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        // backgroundView 생성 및 설정
        let backgroundCellView = UIView()
        backgroundCellView.backgroundColor = .white
        backgroundCellView.layer.cornerRadius = cornerRadius
        self.backgroundView = backgroundCellView

        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        textLabel?.text = text
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: cellPadding, bottom: 0, right: cellPadding))
    }
}

extension TodoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= 0 && section < items.count {
            return items[section].count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        let task = items[indexPath.section][indexPath.row]
        cell.configure(with: task.title)
        cell.backgroundColor = .clear
        if task.done {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .systemGray2
        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
        }
        return cell
    }
}

extension TodoViewController: UITableViewDelegate {
    //
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .white

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }

    // 셀 터치시 작성된 뷰 표시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 터치시 체크마크 표시
        items[indexPath.section][indexPath.row].done.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let task = items[indexPath.section][indexPath.row]

        if task.done {
            doneItems.append(task)
        } else {
            if let index = doneItems.firstIndex(where: { $0.title == task.title }) {
                doneItems.remove(at: index)
            }
        }
        // 전체 할 일 목록을 UserDefaults에 저장
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: "items")
        }
    }

    // 스와이프 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            if items[indexPath.section].isEmpty {
                editButtonTapped()
            }

            // 전체 할 일 목록을 UserDefaults에 저장
            if let data = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(data, forKey: "items")
            }
        }
    }

    // 셀 정렬
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let task = items[sourceIndexPath.section][sourceIndexPath.row]
        items[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        items[destinationIndexPath.section].insert(task, at: destinationIndexPath.row)
    }
}

extension TodoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row]
    }
}

protocol AddTodoDelegate {
    func didSaveNewTodo(todo: String, section: Int)
}

class Task: Codable {
    var title: String
    var done: Bool

    init(title: String, done: Bool = false) {
        self.title = title
        self.done = done
    }
}
