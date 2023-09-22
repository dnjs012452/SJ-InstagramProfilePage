// 할일완료 페이지

import UIKit

class TodoDoneViewController: UIViewController, UITableViewDataSource {
    var tasks: [Task] = []

    private lazy var doneTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupViews()
        setUpConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let data = UserDefaults.standard.data(forKey: "items"),
           let savedItems = try? JSONDecoder().decode([[Task]].self, from: data)
        {
            tasks = savedItems.flatMap { $0 }.filter { $0.done }
            doneTableView.reloadData()
        }
    }

    private func setupViews() {
        view.addSubview(doneTableView)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.black
    }

    // MARK: - 레이아웃

    private func setUpConstraints() {
        var safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            doneTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doneTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            doneTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            doneTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = tasks[indexPath.row].title

        return cell
    }
}
