//
//  HapticFXsExample.swift
//  CupcakeCorner
//  https://youtu.be/jb-tFgZYA0U
//  Created by Uri on 7/3/26.
//

import CoreHaptics
import SwiftUI

struct HapticFXsExample: View {

    @State private var counter: Int = 0

    // Core Haptics
    @State private var engine: CHHapticEngine?

    var body: some View {
        Button("Play Haptic") {
            complexSuccess()
        }
        .onAppear {
            prepareHaptics()
        }
    }
}

#Preview {
    HapticFXsExample()
}

extension HapticFXsExample {

    private var easyHaptic: some View {
        Button("Tap count: \(counter)") {
            counter += 1
        }
        .sensoryFeedback(.increase, trigger: counter)
    }

    // Core Haptics
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            debugPrint("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    private func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        var events: [CHHapticEvent] = []

        // Starts gentle and goes strong
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        // Starts strong and goes gentle
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            debugPrint("Failed to play patter: \(error.localizedDescription)")
        }
    }
}
