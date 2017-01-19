//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Baker, Travis on 1/16/17.
//  Copyright © 2017 Baker, Travis. All rights reserved.
//
//  Built with inspiration and some code reuse from Udacity iOS Nanodegree videos
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    // MARK: Properties
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingButton.isEnabled = false
    }

    // MARK: Actions
    @IBAction func recordAudio(_ sender: Any) {
        updateRecordingUIState(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        updateRecordingUIState(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: UI Functions
    // Update label text and button state
    func updateRecordingUIState(isRecording: Bool) {
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
        
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioUrl = sender as! URL
            playSoundsVC.recordedAudioUrl = recordedAudioUrl
        }
    }
}

// MARK: AVAudioRecorderDelegate
extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            BasicAlert(title: "Error", message: "Recording was not successful").show(in: self)
        }
    }
}

