//
//  PlaybackViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/23/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlaybackViewModelDelegate {
    
    func updateRows()
    func updateSlider(progress: CGFloat)
    
    func didPlay()
    func didStop()
}

class PlaybackViewModel: NSObject, AVAudioPlayerDelegate {
    
    var rows: [PlaybackRow] {
        didSet {
            delegate?.updateRows()
        }
    }
    var section: Section
    var recording: Recording
    var audioPlayer: AVAudioPlayer
    var delegate: PlaybackViewModelDelegate?
    var reloadAction: () -> Void
    
    private var playing = false
    
    init(section: Section, recording: Recording, reloadAction: @escaping () -> Void) {
        self.rows = []
        self.reloadAction = reloadAction
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: recording.url)
        } catch {
            fatalError()
        }
        self.section = section
        self.recording = recording
        super.init()
        
        audioPlayer.prepareToPlay()
        audioPlayer.delegate = self
        
        createRows()
    }
    
    func createRows() {
        self.rows = [ .title(TextFieldCellConfiguration(title: "Title",
                                                        required: true,
                                                        text: recording.title,
                                                        textAction: setTitle(_:),
                                                        allowNewLines: false,
                                                        textAutocapitalizationType: .words))
        ]
    }
    
    func setTitle(_ title: String) {
        recording.title = title
        
        if title == "" {
            recording.title = "New Recording"
        }
    }
    
    func setNote(_ note: String?) {
        recording.note = note
        createRows()
    }
    
    func setPlaybackInterval(percentage: TimeInterval) {
        audioPlayer.currentTime = audioPlayer.duration * percentage
    }
    
    func playSelected() {
        if playing {
            stop()
        } else {
            play()
        }
        playing = !playing
    }
    
    func play() {
        audioPlayer.play()
        delegate?.didPlay()
    }
    
    func stop() {
        audioPlayer.stop()
        delegate?.didStop()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playing = false
        stop()
    }
    
    func deleteSelected() {
        audioPlayer.stop()
        do {
            try FileManager.default.removeItem(at: recording.url)
        } catch {
            assertionFailure("Could not delete recording")
        }
        section.removeFromRecordings(recording)
        recording.delete(writeToDisk: false, completion: { _ in
            self.reloadAction()
        })
    }
}
