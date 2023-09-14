//
//  AddViewController.swift
//  error
//
//  Created by t2023-m0068 on 2023/09/12.
//

import UIKit

class AddViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTap))
        rightButton.tintColor = UIColor.label
        navigationItem.rightBarButtonItem = rightButton

        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.label,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        navigationItem.title = "할일 추가하기"
    }

    @objc func doneButtonTap() {
        //
    }
}
