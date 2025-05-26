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
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 1
    @Published var trackNames: [String] = []
    @Published var activeTrackName: String = ""
    
    private var playlistUsual = ["track1", "track2"]
    private var playlistMidi: [String] = ["track3"]
    
    private var player: AVAudioPlayer?
    private var currentTrackIndex: Int = 0
    private var displayLink: CADisplayLink?
    
    init() {
        switchToPlaylistA()
        configureRemoteCommands()
    }
    
    func switchPlaylist() {
        if trackNames == playlistUsual {
            switchToPlaylistB()
        } else {
            switchToPlaylistA()
        }
    }

    private func switchToPlaylistA() {
        trackNames = playlistUsual
        activeTrackName = trackNames.first ?? ""
        if let index = trackNames.firstIndex(of: activeTrackName) {
            loadTrack(at: index)
        }
    }
    
    private func switchToPlaylistB() {
        trackNames = playlistMidi
        activeTrackName = trackNames.first ?? ""
        if let index = trackNames.firstIndex(of: activeTrackName) {
            loadTrack(at: index)
        }
    }
    
    func loadTrack(at index: Int) {
        guard index >= 0, index < trackNames.count else { return }
        
        currentTrackIndex = index
        activeTrackName = trackNames[index]
        
        guard let url = Bundle.main.url(forResource: activeTrackName, withExtension: "mp3") else {
            print("Audio file not found.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            duration = player?.duration ?? 1
            currentTime = 0
        } catch {
            print("Error loading audio: \(error.localizedDescription)")
        }
    }
    
    func play() {
        player?.play()
        isPlaying = true
        startRemoteControl()
        startDisplayLink()
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
        stopRemoteControl()
        stopDisplayLink()
    }
    
    func togglePlayPause() {
        isPlaying ? pause() : play()
    }
    
    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }
    
    func nextTrack() {
        let nextIndex = (currentTrackIndex + 1) % trackNames.count
        playTrack(at: nextIndex)
    }
    
    func previousTrack() {
        let prevIndex = (currentTrackIndex - 1 + trackNames.count) % trackNames.count
        playTrack(at: prevIndex)
    }
    
    func playTrack(at index: Int) {
        loadTrack(at: index)
        play()
    }
    
    // MARK: - DisplayLink
    private func startDisplayLink() {
        stopDisplayLink()
        displayLink = CADisplayLink(target: self, selector: #selector(updateTime))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateTime() {
        guard let player = player else { return }
        currentTime = player.currentTime
        duration = player.duration
    }
    
    // MARK: - Helpers
    func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    deinit {
        stopDisplayLink()
    }
    
    // MARK: - Configure Remote Commands
    func configureRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Play/Pause command
        commandCenter.playCommand.addTarget { _ in
            self.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { _ in
            self.pause()
            return .success
        }
        
        // Next Track command
        commandCenter.nextTrackCommand.addTarget { _ in
            self.nextTrack()
            return .success
        }
        
        // Previous Track command
        commandCenter.previousTrackCommand.addTarget { _ in
            self.previousTrack()
            return .success
        }
    }
    
    private func startRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    private func stopRemoteControl() {
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
}
