//
//  FavoritesViewController.swift
//  RickMorty
//

@preconcurrency import UIKit

nonisolated private enum FavSection: Int, Hashable, Sendable {
    case characters
    case locations
    case episodes
}

nonisolated private enum FavItem: Hashable, Sendable {
    case character(RMCharacter)
    case location(RMLocation)
    case episode(RMEpisode)
}

final class FavoritesViewController: UIViewController {

    // MARK: - Properties

    private var favoriteCharacters: [RMCharacter] = []
    private var favoriteLocations: [RMLocation] = []
    private var favoriteEpisodes: [RMEpisode] = []

    private var allCharacters: [RMCharacter] = []
    private var allLocations: [RMLocation] = []
    private var allEpisodes: [RMEpisode] = []

    private var dataSource: UICollectionViewDiffableDataSource<FavSection, FavItem>!
    private var collectionView: UICollectionView!
    private var observer: NSObjectProtocol?

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .black)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorites yet.\nTap the heart on any detail page!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupHeader()
        setupCollectionView()
        configureDataSource()

        observer = NotificationCenter.default.addObserver(
            forName: FavoritesManager.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshFavorites()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllDataThenRefresh()
    }

    deinit {
        if let observer { NotificationCenter.default.removeObserver(observer) }
    }

    // MARK: - Setup

    private func setupHeader() {
        view.addSubview(titleLabel)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        collectionView.register(FavLocationCell.self, forCellWithReuseIdentifier: FavLocationCell.reuseIdentifier)
        collectionView.register(FavEpisodeCell.self, forCellWithReuseIdentifier: FavEpisodeCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .estimated(200)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            group.interItemSpacing = .fixed(12)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(36))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]

            return section
        }
    }

    // MARK: - Data Source

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<FavSection, FavItem>(
            collectionView: collectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, item: FavItem) -> UICollectionViewCell? in
            switch item {
            case .character(let character):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell else { return UICollectionViewCell() }
                cell.configure(with: character)
                return cell
            case .location(let location):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavLocationCell.reuseIdentifier, for: indexPath) as? FavLocationCell else { return UICollectionViewCell() }
                cell.configure(with: location)
                return cell
            case .episode(let episode):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavEpisodeCell.reuseIdentifier, for: indexPath) as? FavEpisodeCell else { return UICollectionViewCell() }
                cell.configure(with: episode)
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }
            let section = FavSection(rawValue: indexPath.section)
            switch section {
            case .characters: header.configure(title: "Characters")
            case .locations: header.configure(title: "Locations")
            case .episodes: header.configure(title: "Episodes")
            case .none: break
            }
            return header
        }
    }

    // MARK: - Data Loading

    private func loadAllDataThenRefresh() {
        Task {
            async let charsResponse = NetworkService.shared.fetchCharacters(page: 1)
            async let locsResponse = NetworkService.shared.fetchLocations(page: 1)
            async let epsResponse = NetworkService.shared.fetchEpisodes(page: 1)

            do {
                let (chars, locs, eps) = try await (charsResponse, locsResponse, epsResponse)
                allCharacters = chars.results
                allLocations = locs.results
                allEpisodes = eps.results
            } catch {}

            refreshFavorites()
        }
    }

    private func refreshFavorites() {
        let favCharIDs = FavoritesManager.shared.allFavoriteCharacterIDs
        let favLocIDs = FavoritesManager.shared.allFavoriteLocationIDs
        let favEpIDs = FavoritesManager.shared.allFavoriteEpisodeIDs

        favoriteCharacters = allCharacters.filter { favCharIDs.contains($0.id) }
        favoriteLocations = allLocations.filter { favLocIDs.contains($0.id) }
        favoriteEpisodes = allEpisodes.filter { favEpIDs.contains($0.id) }

        let isEmpty = favoriteCharacters.isEmpty && favoriteLocations.isEmpty && favoriteEpisodes.isEmpty
        emptyLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty

        var snapshot = NSDiffableDataSourceSnapshot<FavSection, FavItem>()

        if !favoriteCharacters.isEmpty {
            snapshot.appendSections([.characters])
            snapshot.appendItems(favoriteCharacters.map { .character($0) }, toSection: .characters)
        }
        if !favoriteLocations.isEmpty {
            snapshot.appendSections([.locations])
            snapshot.appendItems(favoriteLocations.map { .location($0) }, toSection: .locations)
        }
        if !favoriteEpisodes.isEmpty {
            snapshot.appendSections([.episodes])
            snapshot.appendItems(favoriteEpisodes.map { .episode($0) }, toSection: .episodes)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .character(let character):
            let vc = CharacterDetailViewController(character: character)
            navigationController?.pushViewController(vc, animated: true)
        case .location(let location):
            let vc = LocationDetailViewController(location: location)
            navigationController?.pushViewController(vc, animated: true)
        case .episode(let episode):
            let vc = EpisodeDetailViewController(episode: episode)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Section Header View

final class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        label.text = title
    }
}

// MARK: - Simple Favorites Cells (reusing pattern from existing cells)

final class FavLocationCell: UICollectionViewCell {
    static let reuseIdentifier = "FavLocationCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "globe.americas.fill")
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(iconView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(typeLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            typeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with location: RMLocation) {
        nameLabel.text = location.name
        typeLabel.text = location.type
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        typeLabel.text = nil
    }
}

final class FavEpisodeCell: UICollectionViewCell {
    static let reuseIdentifier = "FavEpisodeCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemPurple
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(codeLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            codeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            codeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            codeLabel.heightAnchor.constraint(equalToConstant: 24),

            nameLabel.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with episode: RMEpisode) {
        codeLabel.text = "  \(episode.episode)  "
        nameLabel.text = episode.name
        dateLabel.text = episode.airDate
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        codeLabel.text = nil
        nameLabel.text = nil
        dateLabel.text = nil
    }
}
