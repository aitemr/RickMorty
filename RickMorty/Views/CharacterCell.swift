//
//  CharacterCell.swift
//  RickMorty
//

import UIKit

final class CharacterCell: UICollectionViewCell {
    static let reuseIdentifier = "CharacterCell"

    // MARK: - UI Elements

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let statusBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - State

    private var currentImageURL: String?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageContainerView)
        imageContainerView.addSubview(characterImageView)
        imageContainerView.addSubview(statusBadge)
        containerView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            characterImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor),

            statusBadge.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 8),
            statusBadge.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            statusBadge.heightAnchor.constraint(equalToConstant: 22),

            nameLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }

    // MARK: - Configure

    func configure(with character: RMCharacter) {
        nameLabel.text = character.name
        configureBadge(status: character.status)
        loadImage(urlString: character.image)
    }

    private func configureBadge(status: RMCharacter.Status) {
        statusBadge.text = "  \(status.rawValue.uppercased())  "

        switch status {
        case .alive:
            statusBadge.backgroundColor = UIColor.systemGreen
        case .dead:
            statusBadge.backgroundColor = UIColor.systemRed
        case .unknown:
            statusBadge.backgroundColor = UIColor.systemGray
        }
    }

    private func loadImage(urlString: String) {
        currentImageURL = urlString
        characterImageView.image = nil

        Task {
            let image = await ImageLoader.shared.loadImage(from: urlString)
            guard currentImageURL == urlString else { return }
            characterImageView.image = image
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        currentImageURL = nil
        nameLabel.text = nil
    }
}
