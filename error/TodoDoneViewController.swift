// 할일완료 페이지

import UIKit

class TodoDoneViewController: UIViewController {
    private lazy var doneTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        UIColor(red: 248/255, green: 240/255, blue: 229/255, alpha: 1) // #F8F0E5

        setupNavigationBar()
        setupViews()
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
}
