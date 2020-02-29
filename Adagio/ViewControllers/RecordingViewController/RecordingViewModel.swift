//
//  RecordingViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/20/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import AVFoundation
import CoreData
import SharedPips

protocol RecordingViewModelDelegate {
    
    func setRecord()
    func setStop()
    func updateTimer(with interval: TimeInterval)
    
    func present(error: Error)
    func permissionDenied()
}

class RecordingViewModel: NSObject, AVAudioRecorderDelegate {
    
    var isRecording = false
    var section: Section
    var recording: Recording
    var managedObjectContext: NSManagedObjectContext
    var audioRecorder: AVAudioRecorder!
    var delegate: RecordingViewModelDelegate?
    var doneAction: () -> Void
    
    let uuid = UUID().uuidString
    
    private var audioTimer: Timer?
    
    private var playing = false
    
    init(section: Section, doneAction: @escaping () -> Void) {
        self.section = section
        self.recording = Recording(context: section.managedObjectContext!)
        self.managedObjectContext = section.managedObjectContext!
        self.doneAction = doneAction
        super.init()
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(uuid)
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
        
        recording.url = getFileUrl()
        recording.title = "New Recording"
        setupSession()
        
        section.addToRecordings(recording)
    }
    
    func recordSelected() {
        self.isRecording = !isRecording
        
        if isRecording {
            record()
        } else {
            stop()
        }
    }
    
    private func record() {
        delegate?.setStop()
        audioRecorder.record()
        audioTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (_) in
            self.delegate?.updateTimer(with: self.audioRecorder?.currentTime ?? 0)
            self.audioRecorder?.updateMeters()
        })
    }
    
    private func setupSession() {
        let session = AVAudioSession.sharedInstance()
        do
        {
            try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        catch let error {
            delegate?.present(error: error)
        }
    }
    
    private func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
        audioTimer?.invalidate()
        audioTimer = nil
        delegate?.setRecord()
    }
    
    private func getRecordingDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(uuid, isDirectory: false)
    }

    private func getFileUrl() -> URL
    {
        let filename = "recording.m4a"
        return getRecordingDirectory().appendingPathComponent(filename)
    }
    
    func set(title: String) {
        recording.title = title
    }
    
    func checkPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted: ()
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                    if !allowed {
                        self.delegate?.permissionDenied()
                    }
            })
        default:
            delegate?.permissionDenied()
        }
    }
    
    func cancelSelected() {
        do {
            try FileManager.default.removeItem(at: getFileUrl())
            section.removeFromRecordings(recording)
        } catch {
            assertionFailure("Could not delete recording")
        }
    }
    
    func doneSelected() {
        DispatchQueue(label: "getProperDuration").async {
            do {
                let player = try AVAudioPlayer(contentsOf: self.recording.url)
                self.recording.duration = player.duration
            } catch {
            
            }
        }
        doneAction()
    }
}
