//
//  AVAudioUnitSamplerViewModel.swift
//  MusicSynth
//
//  Created by Oleh on 06.05.2025.
//

import Tonic
import AVFoundation

class AVAudioUnitSamplerViewModel: ObservableObject {
    let firstOctave = 2
    let octaveCount = 2
    let engine = AVAudioEngine()
    var instrument = AVAudioUnitSampler()
    
    init() {
        engine.attach(instrument)
        engine.connect(instrument, to: engine.mainMixerNode, format: nil)
        try? instrument.loadInstrument(at: Bundle.main.url(forResource: "uke", withExtension: "exs")!)
        try? engine.start()
    }
    
    func noteOn(pitch: Pitch, point: CGPoint) {
        instrument.startNote(UInt8(pitch.intValue), withVelocity: 127, onChannel: 0)
    }
    
    func noteOff(pitch: Pitch) {
        instrument.stopNote(UInt8(pitch.intValue), onChannel: 0)
    }
}
