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
    @StateObject var viewModel = AppleSampleViewModel()
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.green.opacity(0.5), .black]), center: .center, startRadius: 2, endRadius: 650).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Keyboard(layout: .piano(pitchRange: Pitch(intValue: viewModel.firstOctave * 12 + 24)...Pitch(intValue: viewModel.firstOctave * 12 + viewModel.octaveCount * 12 + 24)),
                         noteOn: viewModel.noteOn(pitch:point:), noteOff: viewModel.noteOff(pitch:)){ pitch, isActivated in
                    KeyboardKey(pitch: pitch,
                                isActivated: isActivated,
                                text: "",
                                pressedColor: Color.pink,
                                flatTop: true)
                }
            }.onDisappear() { self.viewModel.engine.stop() }
        }
    }
}

#Preview {
    AppleSampleView()
}
