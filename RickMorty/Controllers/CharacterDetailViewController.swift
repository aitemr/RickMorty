//
//  CharacterDetailViewController.swift
//  RickMorty
//

import UIKit

final class CharacterDetailViewController: UIViewController {

    private let character: RMCharacter

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

    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let statusBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
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

    init(character: RMCharacter) {
        self.character = character
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
        contentView.addSubview(heroImageView)
        contentView.addSubview(statusBadge)
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

            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor),

            statusBadge.topAnchor.constraint(equalTo: heroImageView.topAnchor, constant: 16),
            statusBadge.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor, constant: 16),
            statusBadge.heightAnchor.constraint(equalToConstant: 28),

            favoriteButton.topAnchor.constraint(equalTo: heroImageView.topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),

            nameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            infoStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }

    // MARK: - Configure

    private func configure() {
        nameLabel.text = character.name
        configureStatusBadge()
        updateFavoriteButton()
        loadImage()
        addInfoRows()
    }

    private func configureStatusBadge() {
        statusBadge.text = "  \(character.status.rawValue.uppercased())  "
        switch character.status {
        case .alive: statusBadge.backgroundColor = .systemGreen
        case .dead: statusBadge.backgroundColor = .systemRed
        case .unknown: statusBadge.backgroundColor = .systemGray
        }
    }

    private func updateFavoriteButton() {
        let isFav = FavoritesManager.shared.isCharacterFavorite(character.id)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let image = UIImage(systemName: isFav ? "heart.fill" : "heart", withConfiguration: config)
        favoriteButton.setImage(image, for: .normal)
    }

    private func loadImage() {
        Task {
            heroImageView.image = await ImageLoader.shared.loadImage(from: character.image)
        }
    }

    private func addInfoRows() {
        let rows: [(String, String)] = [
            ("Species", character.species),
            ("Gender", character.gender),
            ("Origin", character.origin.name),
            ("Location", character.location.name),
            ("Episodes", "\(character.episode.count) episode(s)"),
        ]

        for (title, value) in rows {
            let row = createInfoRow(title: title, value: value)
            infoStackView.addArrangedSubview(row)
        }
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
        heroImageView.alpha = 0
        heroImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        nameLabel.alpha = 0
        nameLabel.transform = CGAffineTransform(translationX: 0, y: 15)
        statusBadge.alpha = 0
        statusBadge.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        favoriteButton.alpha = 0
    }

    private func animateEntrance() {
        for (index, subview) in infoStackView.arrangedSubviews.enumerated() {
            subview.alpha = 0
            subview.transform = CGAffineTransform(translationX: 0, y: 15)

            UIView.animate(
                withDuration: 0.45,
                delay: 0.25 + Double(index) * 0.06,
                usingSpringWithDamping: 0.85,
                initialSpringVelocity: 0.3,
                options: .curveEaseOut
            ) {
                subview.alpha = 1
                subview.transform = .identity
            }
        }

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.3,
            options: .curveEaseOut
        ) {
            self.heroImageView.alpha = 1
            self.heroImageView.transform = .identity
        }

        UIView.animate(
            withDuration: 0.4,
            delay: 0.1,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.3,
            options: .curveEaseOut
        ) {
            self.statusBadge.alpha = 1
            self.statusBadge.transform = .identity
            self.favoriteButton.alpha = 1
        }

        UIView.animate(
            withDuration: 0.4,
            delay: 0.15,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.3,
            options: .curveEaseOut
        ) {
            self.nameLabel.alpha = 1
            self.nameLabel.transform = .identity
        }
    }

    // MARK: - Actions

    @objc private func toggleFavorite() {
        FavoritesManager.shared.toggleCharacter(character.id)
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
