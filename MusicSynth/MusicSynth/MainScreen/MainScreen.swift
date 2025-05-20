//
//  MainScreen.swift
//  MusicSynth
//
//  Created by Oleh on 20.05.2025.
//

import SwiftUI

struct MainScreen: View {
    @State private var path: [AppRoute] = []
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("Go to Music Audio Player") {
                    path.append(.audioPlayer)
                }
                Button("Go to AVAudio Unit Sampler View") {
                    path.append(.unit)
                }
                Button("Go to  Apple Sampler View") {
                    path.append(.apple)
                }
                Button("Go to Dunne Sampler View") {
                    path.append(.dunne)
                }
            }
            .navigationTitle("Main Screen")
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .audioPlayer:
                    MusicPlayerView()
                case .unit:
                    AVAudioUnitSamplerView()
                case .apple:
                    AppleSampleView()
                case .dunne:
                    DunneSamplerView()
                }
            }
        }
    }
}

enum AppRoute: Hashable {
    case audioPlayer
    case unit
    case dunne
    case apple
}

#Preview {
    MainScreen()
}
