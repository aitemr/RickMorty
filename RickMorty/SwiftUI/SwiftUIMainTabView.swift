//
//  SwiftUIMainTabView.swift
//  RickMorty
//

import SwiftUI

struct SwiftUIMainTabView: View {
    private var loc = LocalizationManager.shared

    var body: some View {
        TabView {
            CharactersListView()
                .tabItem {
                    Label(loc.string("tab.characters"), systemImage: "person.2.fill")
                }

            LocationsListView()
                .tabItem {
                    Label(loc.string("tab.locations"), systemImage: "globe.americas.fill")
                }

            EpisodesListView()
                .tabItem {
                    Label(loc.string("tab.episodes"), systemImage: "play.tv.fill")
                }

            FavoritesView()
                .tabItem {
                    Label(loc.string("tab.favorites"), systemImage: "heart.fill")
                }

            SettingsView()
                .tabItem {
                    Label(loc.string("tab.settings"), systemImage: "gearshape.fill")
                }
        }
        .tint(Theme.accentSwiftUI)
    }
}
