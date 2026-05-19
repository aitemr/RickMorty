//
//  LaunchScreenView.swift
//  RickMorty
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var portalScale: CGFloat = 0.3
    @State private var portalOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var subtitleOpacity: Double = 0
    @State private var ringRotation: Double = 0

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.18, blue: 0.12),
                    Color(red: 0.12, green: 0.30, blue: 0.18),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Portal animation
                ZStack {
                    // Outer rings
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .stroke(
                                Theme.accentSwiftUI.opacity(Double(4 - i) / 6.0),
                                lineWidth: CGFloat(3 - i / 2)
                            )
                            .frame(width: CGFloat(160 - i * 30), height: CGFloat(160 - i * 30))
                            .rotationEffect(.degrees(ringRotation + Double(i * 45)))
                    }

                    // Inner glowing circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.35, green: 0.9, blue: 0.5),
                                    Theme.accentSwiftUI.opacity(0.6),
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: Theme.accentSwiftUI.opacity(0.6), radius: 20)

                    // RM text
                    Text("RM")
                        .font(.system(size: 36, weight: .black))
                        .foregroundStyle(Color(red: 0.08, green: 0.18, blue: 0.12))
                }
                .scaleEffect(portalScale)
                .opacity(portalOpacity)

                // Title
                VStack(spacing: 6) {
                    (Text("The ")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                    + Text("Rick and Morty")
                        .font(.system(size: 22, weight: .heavy).italic())
                        .foregroundColor(Color(red: 0.35, green: 0.9, blue: 0.5))
                    )
                    .opacity(titleOpacity)
                    .offset(y: titleOffset)

                    Text("DIMENSION GUIDE")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(4)
                        .foregroundStyle(.white.opacity(0.5))
                        .opacity(subtitleOpacity)
                }

                Spacer()
                Spacer()
            }
        }
        .onAppear {
            // Portal scale in
            withAnimation(.spring(duration: 0.8, bounce: 0.3)) {
                portalScale = 1.0
                portalOpacity = 1.0
            }

            // Ring rotation
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                ringRotation = 360
            }

            // Title fade in
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                titleOpacity = 1.0
                titleOffset = 0
            }

            // Subtitle fade in
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                subtitleOpacity = 1.0
            }
        }
    }
}
