//
//  MusicPlayerView.swift
//  MusicSynth
//
//  Created by Oleh on 12.05.2025.
//

import SwiftUI

struct MusicPlayerView: View {
    @StateObject private var audioManager = AudioManager()
    
    var body: some View {
        VStack(spacing: 20) {
            // 📜 Track List
            List {
                ForEach(Array(audioManager.trackNames.enumerated()), id: \.offset) { index, name in
                    HStack {
                        Text(name)
                            .fontWeight(audioManager.activeTrackName == name ? .bold : .regular)
                        Spacer()
                        if audioManager.activeTrackName == name {
                            Image(systemName: "music.note")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        audioManager.playTrack(at: index)
                    }
                }
            }
            
            // 🎵 Current Track
            Text(audioManager.activeTrackName)
                .font(.title2)
                .padding(.top)
            
            // 🕓 Time Labels & Slider
            VStack {
                HStack {
                    Text(audioManager.formatTime(audioManager.currentTime))
                    Spacer()
                    Text(audioManager.formatTime(audioManager.duration))
                }
                Slider(
                    value: Binding(
                        get: { audioManager.currentTime },
                        set: { newValue in
                            audioManager.seek(to: newValue)
                        }
                    ),
                    in: 0...audioManager.duration
                )
            }
            .padding()
            
            // ▶️ Player Controls
            HStack(spacing: 40) {
                Button(action: {
                    audioManager.previousTrack()
                }) {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                Button(action: {
                    audioManager.togglePlayPause()
                }) {
                    Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Button(action: {
                    audioManager.nextTrack()
                }) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

#Preview {
    MusicPlayerView()
}
