//
//  AudioService.swift
//  Shazayita
//
//  Created by Henry Javier Serrano Echeverria on 2/1/22.
//

import Foundation
import ShazamKit
import AVKit

protocol AudioService {
    func isRunning() async -> Bool
    func recognizeAndMatch(from inputSource: AudioServiceInputSource) async throws -> AudioMatch
    func stop() async
}

enum AudioServiceInputSource {
    case microphone
}

enum AudioServiceError: Error {
    case unknown
    case stopped
}

actor StandardAudioService: NSObject {
    
    private let session = SHSession()
    private lazy var engine = AVAudioEngine()
    private lazy var isRecognizingSong = false
    private var savedContinuation: CheckedContinuation<AudioMatch, Error>?
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    func startRecognition() {
        if engine.isRunning {
            stopRecognition()
            return
        }
        
        do {
            try prepareAudioRecording()
                
            generateSignature()
                
            try startAudioRecording()
        } catch {
            // Handle errors here
            print(error)
        }
    }

    func stopRecognition() {
        isRecognizingSong = false
        engine.stop()
        engine.inputNode.removeTap(onBus: .zero)
    }
    
    private func prepareAudioRecording() throws {
        let audioSession = AVAudioSession.sharedInstance()
        
        try audioSession.setCategory(.record)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
      
    private func generateSignature() {
        let inputNode = engine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: .zero)
        
        inputNode.installTap(
            onBus: .zero,
            bufferSize: 1024,
            format: recordingFormat
        ) { [weak session] buffer, _ in
            session?.matchStreamingBuffer(buffer, at: nil)
        }
    }
      
    private func startAudioRecording() throws {
        try engine.start()
        
        isRecognizingSong = true
    }
        
    private func processResultMatch(_ result: Result<AudioMatch, Error>) {
        guard let continuation = savedContinuation else { return }
        continuation.resume(with: result)
        savedContinuation = nil
        stopRecognition()
    }
    
}

extension StandardAudioService: AudioService {
    func isRunning() async -> Bool {
        isRecognizingSong
    }
    
    func recognizeAndMatch(from inputSource: AudioServiceInputSource) async throws -> AudioMatch {
        return try await withCheckedThrowingContinuation { continuation in
            savedContinuation = continuation
            startRecognition()
        }
    }
    
    func stop() async {
        processResultMatch(.failure(AudioServiceError.stopped))
    }
}

extension StandardAudioService: SHSessionDelegate {
    nonisolated func session(_ session: SHSession, didFind match: SHMatch) {
        guard let mediaItem = match.mediaItems.first,
              let audioMatch = AudioMatch(from: mediaItem) else { return }
        print(audioMatch)
        Task {
            await processResultMatch(.success(audioMatch))
        }
    }
    
    nonisolated func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        Task {
            await processResultMatch(.failure(error ?? AudioServiceError.unknown))
        }
    }
}
