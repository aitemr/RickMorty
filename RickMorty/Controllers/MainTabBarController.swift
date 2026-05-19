//
//  MainTabBarController.swift
//  RickMorty
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        let charactersVC = CharactersViewController()
        let charactersNav = UINavigationController(rootViewController: charactersVC)
        charactersNav.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person.2"),
            selectedImage: UIImage(systemName: "person.2.fill")
        )

        let locationsVC = LocationsViewController()
        let locationsNav = UINavigationController(rootViewController: locationsVC)
        locationsNav.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "globe"),
            selectedImage: UIImage(systemName: "globe.americas.fill")
        )

        let episodesVC = EpisodesViewController()
        let episodesNav = UINavigationController(rootViewController: episodesVC)
        episodesNav.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "play.tv"),
            selectedImage: UIImage(systemName: "play.tv.fill")
        )

        let favoritesVC = FavoritesViewController()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )

        viewControllers = [charactersNav, locationsNav, episodesNav, favoritesNav, settingsNav]
        selectedIndex = 0
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = Theme.accentColor
    }
}
