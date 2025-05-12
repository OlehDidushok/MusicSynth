//
//  AudioManager.swift
//  MusicSynth
//
//  Created by Oleh on 12.05.2025.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioManager: ObservableObject {
    private var player: AVAudioPlayer?
    private var currentTrackIndex = 0
    private let tracks = ["track1", "track2", "track3"] // my music
    private var timer: Timer?
    
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var activeTrackName: String = ""
    
    var trackNames: [String] {
        tracks
    }
    
    init() {
        configureRemoteCommands()
        loadTrack(at: currentTrackIndex)
    }
    
    private func loadTrack(at index: Int) {
        guard let url = Bundle.main.url(forResource: tracks[index], withExtension: "mp3") else {
            print("Track not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            duration = player?.duration ?? 0
            activeTrackName = tracks[index]
            startProgressUpdates()
        } catch {
            print("Failed to load track: \(error)")
        }
    }
    
    func playPause() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopProgressUpdates()
        } else {
            player.play()
            isPlaying = true
            startProgressUpdates()
        }
    }
    
    func nextTrack() {
        currentTrackIndex = (currentTrackIndex + 1) % tracks.count
        loadTrack(at: currentTrackIndex)
        player?.play()
        isPlaying = true
    }
    
    func previousTrack() {
        currentTrackIndex = (currentTrackIndex - 1 + tracks.count) % tracks.count
        loadTrack(at: currentTrackIndex)
        player?.play()
        isPlaying = true
    }
    
    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func startProgressUpdates() {
        stopProgressUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            self.currentTime = player.currentTime
            self.duration = player.duration
        }
    }
    
    private func stopProgressUpdates() {
        timer?.invalidate()
        timer = nil
    }
    
    private func configureRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.playPause()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.playPause()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.nextTrack()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.previousTrack()
            return .success
        }
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
}
