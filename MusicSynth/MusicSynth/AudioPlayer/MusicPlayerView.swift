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
                    // Now playing label
                    Text("Now Playing: \(audioManager.activeTrackName.capitalized)")
                        .font(.headline)
                        .padding(.top)

                    // Progress slider
                    VStack {
                        Slider(value: Binding(
                            get: { audioManager.currentTime },
                            set: { audioManager.seek(to: $0) }
                        ), in: 0...(audioManager.duration == 0 ? 1 : audioManager.duration))

                        HStack {
                            Text(audioManager.formatTime(audioManager.currentTime))
                            Spacer()
                            Text(audioManager.formatTime(audioManager.duration))
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                    .padding(.horizontal)

                    // Playback controls
                    HStack(spacing: 40) {
                        Button(action: {
                            audioManager.previousTrack()
                        }) {
                            Image(systemName: "backward.fill")
                                .font(.largeTitle)
                        }

                        Button(action: {
                            audioManager.playPause()
                        }) {
                            Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                        }

                        Button(action: {
                            audioManager.nextTrack()
                        }) {
                            Image(systemName: "forward.fill")
                                .font(.largeTitle)
                        }
                    }

                    Divider().padding(.top, 20)

                    // Track list
                    List {
                        ForEach(Array(audioManager.trackNames.enumerated()), id: \.offset) { index, name in
                            HStack {
                                Text(name.capitalized)
                                    .foregroundColor(audioManager.activeTrackName == name ? .blue : .primary)
                                if audioManager.activeTrackName == name {
                                    Spacer()
                                    Image(systemName: "music.note")
                                }
                            }
                            .onTapGesture {
                                audioManager.seek(to: 0)
                                audioManager.previousTrack()
                                for _ in 0..<(index - audioManager.trackNames.firstIndex(of: audioManager.activeTrackName)!) {
                                    audioManager.nextTrack()
                                }
                            }
                        }
                    }
                }
                .padding()
    }
}

#Preview {
    MusicPlayerView()
}
