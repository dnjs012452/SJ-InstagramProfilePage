//
//  postAddViewController.swift
//  error
//
//  Created by t2023-m0068 on 2023/09/15.
//

import UIKit

class postAddViewController: UIViewController {
    // 프로필 이미지뷰
    private lazy var postProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true

        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "default_profile")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 75

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postProfileImageTapped))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }()

    // 그림자 뷰
    private lazy var postshadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false

        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 50

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupViews()
        setUpConstraints()
    }

    private func setupViews() {
        postshadowView.addSubview(postProfileImageView)
        view.addSubview(postshadowView)
    }

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // 그림자 뷰
            postshadowView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            postshadowView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            postshadowView.widthAnchor.constraint(equalToConstant: 150),
            postshadowView.heightAnchor.constraint(equalToConstant: 150),

            // 프로필이미지 뷰
            postProfileImageView.topAnchor.constraint(equalTo: postshadowView.topAnchor),
            postProfileImageView.leadingAnchor.constraint(equalTo: postshadowView.leadingAnchor),
            postProfileImageView.trailingAnchor.constraint(equalTo: postshadowView.trailingAnchor),
            postProfileImageView.bottomAnchor.constraint(equalTo: postshadowView.bottomAnchor),

        ])
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
        navigationItem.title = "게시글 추가"
    }

    @objc func doneButtonTap() {
        //
    }

    // 프로필 이미지 눌렀을때
    @objc func postProfileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        present(imagePickerController, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let postSelectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            postProfileImageView.image = postSelectedImage
            dismiss(animated: true, completion: nil)
        }
    }
}

extension postAddViewController: UIImagePickerControllerDelegate {
    //
}

extension postAddViewController: UINavigationControllerDelegate {
    //
}
