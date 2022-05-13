//
//  ProfileCell.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/9/22.
//

import UIKit
import Combine

final class ProfileCell: UITableViewCell {

    static let reuseIdentifier = "ProfileCell"
    
    private var profilePhotoView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private var favouriteBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = UIColor.blue
        button.addTarget(self, action: #selector(didTapFavouriteBtn), for: .touchUpInside)
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: ProfileCellVM!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profilePhotoView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favouriteBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        setUpConstraints()
    }

    private func setUpConstraints() {
        [profilePhotoView, titleLabel, favouriteBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profilePhotoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profilePhotoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profilePhotoView.widthAnchor.constraint(equalToConstant: 40),
            profilePhotoView.heightAnchor.constraint(equalToConstant: 40),
            profilePhotoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            titleLabel.centerYAnchor.constraint(equalTo: profilePhotoView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: profilePhotoView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: favouriteBtn.leadingAnchor, constant: -20),
            
            favouriteBtn.centerYAnchor.constraint(equalTo: profilePhotoView.centerYAnchor),
            favouriteBtn.widthAnchor.constraint(equalToConstant: 44),
            favouriteBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    func configure(with viewModel: ProfileCellVM) {
        self.viewModel = viewModel
        self.viewModel.downloadImage()
        self.viewModel.$profile
            .receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] profile in \(profile.isFavourited ?? false)")
                self?.titleLabel.text = profile.login
                self?.favouriteBtn.setImage(
                    UIImage(systemName: profile.isFavourited ?? false ?
                            "heart.fill" : "heart"), for: .normal)
            }
            .store(in: &cancellables)
        
        self.viewModel.$profileImage
            .sink { [weak self] in self?.profilePhotoView.image = $0?.image }
            .store(in: &cancellables)
    }
    
    @objc func didTapFavouriteBtn() {
        viewModel.addToFavourites()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        profilePhotoView.image = nil
        viewModel.cancelImageDownload()
    }

}
