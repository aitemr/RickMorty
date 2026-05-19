//
//  CharactersViewController.swift
//  RickMorty
//

// TODO:
// 1. add placeholder for them empty images
// 2. add loader, empty state pages when no data
// 3. loading when pagation
// 4 make on swiftui
// 5. make refatoring, make with HIG & Apple architecture guidlines
// 6. add documentation how project works in russian
@preconcurrency import UIKit

nonisolated private enum CharacterSection: Int, Hashable, Sendable {
    case main
}

final class CharactersViewController: UIViewController {

    // MARK: - Properties

    private var characters: [RMCharacter] = []
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false

    private var dataSource: UICollectionViewDiffableDataSource<CharacterSection, RMCharacter>!
    private var collectionView: UICollectionView!

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 2

        let line1 = NSMutableAttributedString(
            string: "The ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 22, weight: .bold),
                .foregroundColor: UIColor.label,
                .paragraphStyle: paragraph,
            ]
        )
        if let italicBoldDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2)
            .withSymbolicTraits([.traitBold, .traitItalic]) {
            let italicBoldFont = UIFont(descriptor: italicBoldDescriptor, size: 24)
            line1.append(NSAttributedString(
                string: "Rick and Morty",
                attributes: [
                    .font: italicBoldFont,
                    .foregroundColor: UIColor(red: 0.2, green: 0.5, blue: 0.3, alpha: 1.0),
                ]
            ))
        } else {
            line1.append(NSAttributedString(
                string: "Rick and Morty",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 24, weight: .black),
                    .foregroundColor: UIColor(red: 0.2, green: 0.5, blue: 0.3, alpha: 1.0),
                ]
            ))
        }

        let line2 = NSAttributedString(
            string: "\nDIMENSION GUIDE",
            attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .bold),
                .foregroundColor: UIColor.secondaryLabel,
                .kern: 3.0,
                .paragraphStyle: paragraph,
            ]
        )

        line1.append(line2)
        label.attributedText = line1

        return label
    }()

    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["CHARACTERS", "LOCATIONS"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false

        let greenColor = UIColor(red: 0.2, green: 0.5, blue: 0.3, alpha: 1.0)
        sc.selectedSegmentTintColor = greenColor
        sc.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 13, weight: .bold),
        ], for: .selected)
        sc.setTitleTextAttributes([
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
        ], for: .normal)

        return sc
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupHeader()
        setupCollectionView()
        configureDataSource()
        loadCharacters()
    }

    // MARK: - Setup Header

    private func setupHeader() {
        view.addSubview(titleLabel)
        view.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    // MARK: - Setup Collection View

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(240)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(12)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - Data Source

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<CharacterSection, RMCharacter>(
            collectionView: collectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, character: RMCharacter) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharacterCell.reuseIdentifier,
                for: indexPath
            ) as? CharacterCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: character)
            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<CharacterSection, RMCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Networking

    private func loadCharacters() {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true

        Task {
            do {
                let response = try await NetworkService.shared.fetchCharacters(page: currentPage)
                totalPages = response.info.pages
                characters.append(contentsOf: response.results)
                applySnapshot()
                currentPage += 1
            } catch {
                if characters.isEmpty {
                    showError(error)
                }
            }
            isLoading = false
        }
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        guard contentHeight > 0, offsetY > 0 else { return }

        if offsetY > contentHeight - frameHeight * 1.5 {
            loadCharacters()
        }
    }
}
