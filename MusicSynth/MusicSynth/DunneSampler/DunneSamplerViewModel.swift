//
//  DunneSamplerViewModel.swift
//  MusicSynth
//
//  Created by Oleh on 06.05.2025.
//

import Foundation
import AudioKit
import Tonic
import DunneAudioKit

class DunneSamplerViewModel: ObservableObject {
    let firstOctave = 2
    let octaveCount = 2
    let engine = AudioEngine()
    var instrument = Sampler()
    init() {
        engine.output = instrument
        instrument.loadSFZ(url: Bundle.main.url(forResource: "sqr", withExtension: "SFZ")!)
        instrument.masterVolume = 0.15
        try? engine.start()
    }
    func noteOn(pitch: Pitch, point: CGPoint) {
        instrument.play(noteNumber: MIDINoteNumber(pitch.intValue), velocity: 127, channel: 0)
    }
    func noteOff(pitch: Pitch) {
        instrument.stop(noteNumber: MIDINoteNumber(pitch.intValue), channel: 0)
    }
}
