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
    @Published var animationScale = 0.0
    
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
            if let match = try? await audioService.recognizeAndMatch(from: .microphone) {
                print(match)
                latestMatch = match
            }
            // TODO: handle error
            
            updateRecognizingStatus(false)
        }
    }
    
    private func updateRecognizingStatus(_ status: Bool) {
        isRecognizingSong = status
        animationScale = status ? 2.0 : 1.0
    }
}

