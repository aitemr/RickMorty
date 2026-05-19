//
//  SwiftUIMainTabView.swift
//  RickMorty
//

import SwiftUI

struct SwiftUIMainTabView: View {
    var body: some View {
        TabView {
            CharactersListView()
                .tabItem {
                    Label("Characters", systemImage: "person.2.fill")
                }

            LocationsListView()
                .tabItem {
                    Label("Locations", systemImage: "globe.americas.fill")
                }

            EpisodesListView()
                .tabItem {
                    Label("Episodes", systemImage: "play.tv.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Theme.accentSwiftUI)
    }
}
