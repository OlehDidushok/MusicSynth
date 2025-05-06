//
//  AppleSampleModel.swift
//  MusicSynth
//
//  Created by Oleh on 06.05.2025.
//

import SwiftUI
import AudioKit
import Keyboard
import Tonic

class AppleSampleViewModel: ObservableObject  {
    let firstOctave = 2
    let octaveCount = 2
    let engine = AudioEngine()
    var instrument = AppleSampler()
    
    init() {
        engine.output = instrument
        try? instrument.loadInstrument(url: Bundle.main.url(forResource: "uke", withExtension: "exs")!)
        try? engine.start()
    }
    
    func noteOn(pitch: Pitch, point: CGPoint) {
        instrument.play(noteNumber: MIDINoteNumber(pitch.intValue), velocity: 127, channel: 0)
    }
    
    func noteOff(pitch: Pitch) {
        instrument.stop(noteNumber: MIDINoteNumber(pitch.intValue), channel: 0)
    }
}
