//
//  EpisodeCell.swift
//  RickMorty
//

import UIKit

final class EpisodeCell: UICollectionViewCell {
    static let reuseIdentifier = "EpisodeCell"

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

    private let episodeCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = Theme.accentColor
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let charactersLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = Theme.accentColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        containerView.addSubview(episodeCodeLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(airDateLabel)
        containerView.addSubview(charactersLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            episodeCodeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            episodeCodeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            episodeCodeLabel.heightAnchor.constraint(equalToConstant: 26),

            nameLabel.topAnchor.constraint(equalTo: episodeCodeLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            airDateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            airDateLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            charactersLabel.topAnchor.constraint(equalTo: airDateLabel.bottomAnchor, constant: 8),
            charactersLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            charactersLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            charactersLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }

    // MARK: - Configure

    func configure(with episode: RMEpisode) {
        episodeCodeLabel.text = "  \(episode.episode)  "
        nameLabel.text = episode.name
        airDateLabel.text = episode.airDate
        charactersLabel.text = "\(episode.characters.count) characters"

        isAccessibilityElement = true
        accessibilityLabel = "\(episode.name), \(episode.episode)"
        accessibilityTraits = .button
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        episodeCodeLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
        charactersLabel.text = nil
    }
}
