//
//  AppleSampleView.swift
//  MusicSynth
//
//  Created by Oleh on 06.05.2025.
//

import Foundation
import SwiftUI
import Keyboard
import Tonic
import AudioKit

struct AppleSampleView: View {
    @StateObject var conductor = AppleSampleViewModel()
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.green.opacity(0.5), .black]), center: .center, startRadius: 2, endRadius: 650).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                SwiftUIKeyboard(firstOctave: 2, octaveCount: 2, noteOn: conductor.noteOn(pitch:point:), noteOff: conductor.noteOff).frame(maxHeight: 600)
            }
        }.onDisappear() { self.conductor.engine.stop() }
    }
}

struct SwiftUIKeyboard: View {
    var firstOctave: Int
    var octaveCount: Int
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in }
    var noteOff: (Pitch)->Void
    var body: some View {
        Keyboard(layout: .piano(pitchRange: Pitch(intValue: firstOctave * 12 + 24)...Pitch(intValue: firstOctave * 12 + octaveCount * 12 + 24)),
                 noteOn: noteOn, noteOff: noteOff){ pitch, isActivated in
            KeyboardKey(pitch: pitch,
                        isActivated: isActivated,
                        text: "",
                        pressedColor: Color.pink,
                        flatTop: true)
        }.cornerRadius(5)
    }
}

#Preview {
    AppleSampleView()
}
