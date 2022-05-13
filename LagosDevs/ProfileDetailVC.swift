//
//  ProfileDetailVC.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/9/22.
//

import UIKit
import Combine

class ProfileDetailVC: UIViewController {

    private var profilePhotoView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private var dismissBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.blue
        button.addTarget(self, action: #selector(didTapDismissBtn), for: .touchUpInside)
        return button
    }()
    
    @Published var profileVM: ProfileCellVM!
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        setUpConstraints()
        setUpBindings()
    }
    
    private func setUp() {
        view.addSubview(profilePhotoView)
        view.addSubview(titleLabel)
        view.addSubview(dismissBtn)
    }
    
    private func setUpConstraints() {
        let guide = view.safeAreaLayoutGuide
        [profilePhotoView, titleLabel, dismissBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profilePhotoView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 50),
            profilePhotoView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            profilePhotoView.widthAnchor.constraint(equalToConstant: 100),
            profilePhotoView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.centerXAnchor.constraint(equalTo: profilePhotoView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: profilePhotoView.bottomAnchor, constant: 20),
            
            dismissBtn.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
            dismissBtn.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            dismissBtn.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setUpBindings() {
        profileVM.downloadImage()
        
        profileVM.$profile
            .receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] profile in
                self?.titleLabel.text = profile.login            }
            .store(in: &cancellables)
        
        profileVM.$profileImage
            .sink { [weak self] in self?.profilePhotoView.image = $0?.image }
            .store(in: &cancellables)
        
    }

    @objc private func didTapDismissBtn() {
        dismiss(animated: true, completion: nil)
    }
}
