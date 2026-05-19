//
//  LocationsViewController.swift
//  RickMorty
//

@preconcurrency import UIKit

nonisolated private enum LocationSection: Int, Hashable, Sendable {
    case main
}

final class LocationsViewController: UIViewController {

    // MARK: - Properties

    private var locations: [RMLocation] = []
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false

    private var dataSource: UICollectionViewDiffableDataSource<LocationSection, RMLocation>!
    private var collectionView: UICollectionView!

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Locations"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .black)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .light)
        let imageView = UIImageView(image: UIImage(systemName: "wifi.slash", withConfiguration: config))
        imageView.tintColor = .secondaryLabel

        let label = UILabel()
        label.text = "No data available"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel

        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.tintColor = Theme.accentColor
        button.tag = 100

        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(button)
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        return view
    }()

    private let paginationSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupHeader()
        setupCollectionView()
        setupLoadingStates()
        configureDataSource()
        loadLocations()
    }

    // MARK: - Setup Header

    private func setupHeader() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    // MARK: - Setup Collection View

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(LocationCell.self, forCellWithReuseIdentifier: LocationCell.reuseIdentifier)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupLoadingStates() {
        view.addSubview(loadingSpinner)
        view.addSubview(emptyStateView)
        view.addSubview(paginationSpinner)

        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyStateView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            paginationSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paginationSpinner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])

        if let retryButton = emptyStateView.viewWithTag(100) as? UIButton {
            retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        }
    }

    @objc private func retryTapped() {
        currentPage = 1
        totalPages = 1
        locations.removeAll()
        emptyStateView.isHidden = true
        loadLocations()
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
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
        dataSource = UICollectionViewDiffableDataSource<LocationSection, RMLocation>(
            collectionView: collectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, location: RMLocation) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LocationCell.reuseIdentifier,
                for: indexPath
            ) as? LocationCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: location)
            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<LocationSection, RMLocation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(locations)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Networking

    private func loadLocations() {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true

        let isFirstPage = currentPage == 1
        if isFirstPage {
            loadingSpinner.startAnimating()
            collectionView.isHidden = true
        } else {
            paginationSpinner.startAnimating()
        }

        Task {
            do {
                let response = try await NetworkService.shared.fetchLocations(page: currentPage)
                totalPages = response.info.pages
                locations.append(contentsOf: response.results)
                applySnapshot()
                currentPage += 1

                if isFirstPage {
                    loadingSpinner.stopAnimating()
                    collectionView.isHidden = false
                } else {
                    paginationSpinner.stopAnimating()
                }
            } catch {
                if isFirstPage {
                    loadingSpinner.stopAnimating()
                    emptyStateView.isHidden = false
                } else {
                    paginationSpinner.stopAnimating()
                }
            }
            isLoading = false
        }
    }
}

// MARK: - UICollectionViewDelegate

extension LocationsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let location = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = LocationDetailViewController(location: location)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        guard contentHeight > 0, offsetY > 0 else { return }

        if offsetY > contentHeight - frameHeight * 1.5 {
            loadLocations()
        }
    }
}
