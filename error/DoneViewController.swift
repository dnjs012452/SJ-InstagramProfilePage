//
//  DoneViewController.swift
//  error
//
//  Created by t2023-m0068 on 2023/09/12.
//

import UIKit

class DoneViewController: UIViewController {
    private lazy var doneTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

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
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            doneTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doneTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            doneTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            doneTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
