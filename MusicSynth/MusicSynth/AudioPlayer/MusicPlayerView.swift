//
//  MusicPlayerView.swift
//  MusicSynth
//
//  Created by Oleh on 12.05.2025.
//

import SwiftUI

struct MusicPlayerView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var isSwitched = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            List(audioManager.trackNames, id: \.self) { song in
                HStack {
                    Text(song)
                        .fontWeight(song == audioManager.activeTrackName ? .bold : .regular)
                    Spacer()
                    if song == audioManager.activeTrackName {
                        Image(systemName: "music.note")
                    }
                }
                .contentShape(Rectangle()) // makes the entire row tappable
                .onTapGesture {
                    if let index = audioManager.trackNames.firstIndex(of: song) {
                        audioManager.loadTrack(at: index)
                        audioManager.play()
                    }
                }
            }
            
            HStack {
                Spacer()
                Toggle("Arc music", isOn: $isSwitched)
                    .onChange(of: isSwitched) {
                        audioManager.switchPlaylist()
                    }
                    .toggleStyle(SwitchToggleStyle())
                    .padding()
            }
            
            Text(audioManager.activeTrackName)
                .font(.title2)
                .padding(.top)
            
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
