//
//  EpisodeDetailViewController.swift
//  RickMorty
//

import UIKit

final class EpisodeDetailViewController: UIViewController {

    private let episode: RMEpisode

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let episodeCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = Theme.accentColor
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .systemRed
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let infoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Init

    init(episode: RMEpisode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .never

        setupUI()
        configure()
        prepareForEntrance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateEntrance()
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(episodeCodeLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoStackView)

        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            episodeCodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            episodeCodeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            episodeCodeLabel.heightAnchor.constraint(equalToConstant: 44),
            episodeCodeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),

            favoriteButton.centerYAnchor.constraint(equalTo: episodeCodeLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),

            nameLabel.topAnchor.constraint(equalTo: episodeCodeLabel.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            infoStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }

    // MARK: - Configure

    private func configure() {
        episodeCodeLabel.text = "  \(episode.episode)  "
        nameLabel.text = episode.name
        updateFavoriteButton()

        let rows: [(String, String)] = [
            ("Air Date", episode.airDate),
            ("Episode Code", episode.episode),
            ("Characters", "\(episode.characters.count) character(s)"),
        ]

        for (title, value) in rows {
            infoStackView.addArrangedSubview(createInfoRow(title: title, value: value))
        }
    }

    private func updateFavoriteButton() {
        let isFav = FavoritesManager.shared.isEpisodeFavorite(episode.id)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let image = UIImage(systemName: isFav ? "heart.fill" : "heart", withConfiguration: config)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.accessibilityLabel = isFav ? "Remove from favorites" : "Add to favorites"
    }

    private func createInfoRow(title: String, value: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        valueLabel.textColor = .label
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(titleLabel)
        container.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
        ])

        return container
    }

    // MARK: - Animation

    private func prepareForEntrance() {
        episodeCodeLabel.alpha = 0
        episodeCodeLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        nameLabel.alpha = 0
        nameLabel.transform = CGAffineTransform(translationX: 0, y: 15)
        favoriteButton.alpha = 0
    }

    private func animateEntrance() {
        for (index, subview) in infoStackView.arrangedSubviews.enumerated() {
            subview.alpha = 0
            subview.transform = CGAffineTransform(translationX: 0, y: 15)
            UIView.animate(withDuration: 0.45, delay: 0.25 + Double(index) * 0.06, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.3, options: .curveEaseOut) {
                subview.alpha = 1
                subview.transform = .identity
            }
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseOut) {
            self.episodeCodeLabel.alpha = 1
            self.episodeCodeLabel.transform = .identity
        }

        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.3, options: .curveEaseOut) {
            self.nameLabel.alpha = 1
            self.nameLabel.transform = .identity
            self.favoriteButton.alpha = 1
        }
    }

    // MARK: - Actions

    @objc private func toggleFavorite() {
        FavoritesManager.shared.toggleEpisode(episode.id)
        updateFavoriteButton()
        UIView.animate(withDuration: 0.2, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.favoriteButton.transform = .identity
            }
        }
    }
}
