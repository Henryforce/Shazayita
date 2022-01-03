//
//  ViewModel.swift
//  Shazayita
//
//  Created by Henry Javier Serrano Echeverria on 2/1/22.
//

import Foundation
import ShazamKit
import AVKit

@MainActor
final class ViewModel: ObservableObject {
    @Published private(set) var isRecognizingSong = false
    private(set) var latestMatch: AudioMatch?
    
    private let audioService: AudioService
    
    init(
        audioService: AudioService = StandardAudioService()
    ) {
        self.audioService = audioService
    }
    
    func startStopRecognition() {
        Task {            
            if await audioService.isRunning() {
                await audioService.stop()
                updateRecognizingStatus(false)
                return
            }
            
            updateRecognizingStatus(true)
            guard let match = try? await audioService.recognizeAndMatch(from: .microphone) else { return }
            print(match)
            latestMatch = match
            
            updateRecognizingStatus(false)
        }
    }
    
    private func updateRecognizingStatus(_ status: Bool) {
        isRecognizingSong = status
    }
}

