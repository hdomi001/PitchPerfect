//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Hector Dominguez jr on 4/25/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    // Audio Recorder
    var audioRecorderManager: AVAudioRecorder!
    
    // MARK: RecordSoundsViewController IBOutlets
    @IBOutlet weak var audioRecordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!

    // Constants
    let SEGUE_IDENTIFIER_PLAYSOUNDSVIEWCONTROLLER: String = "stopRecording"
    let TAP_TO_RECORD: String = "Tap to Record"
    let RECORDING_IN_PROGRESS: String = "Recording in progress"
    let RECORDING_NAME: String = "recordedVoice.wav"

    /*
    Called once the MainView of a RecordSoundsViewController has been loaded.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ensures that the Stop recording button is initially disabled
        // Thus, only recording button is enabled
        updateUI(recording: false)
    }

    /*
    Creates a temporary directory to store the recording and starts recording the audio from the user
    */
    @IBAction func recordAudio(_ sender: Any) {
        updateUI(recording: true)

        let filePath = createRecordingPath(recordingName: RECORDING_NAME)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord,
                         mode: AVAudioSession.Mode.default,
                         options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorderManager = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorderManager.delegate = self
        audioRecorderManager.isMeteringEnabled = true
        audioRecorderManager.prepareToRecord()
        audioRecorderManager.record()
    }

    /*
    Stops recording audio from the user
    */
    @IBAction func stopRecording(_ sender: Any) {
        updateUI(recording: false)
        audioRecorderManager.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    /*
    When the recording finishes, it sends the audio file to next controller via prepareSegue
    */
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: SEGUE_IDENTIFIER_PLAYSOUNDSVIEWCONTROLLER, sender: audioRecorderManager.url)
        } else {
            print("recording was not succesful")
        }
    }

    /*
    Prepare method for which is in chanrge of updating the Play Sounds View Controller.
    Sends the recording to the next view for further processing
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_IDENTIFIER_PLAYSOUNDSVIEWCONTROLLER {
            let playSoundsVCS = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVCS.recordedAudioURL = recordedAudioURL
        }
    }

    /*
    Creates the URL of where the Recording will be saved.
    */
    private func createRecordingPath(recordingName: String) -> URL? {
        let recordingPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let pathArray = [recordingPath, recordingName]
        return URL(string: pathArray.joined(separator: "/"))
    }

    /*
    Update UI Buttons and Labels
    */
    private func updateUI(recording: Bool) {
        if recording {
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            audioRecordingLabel.text = RECORDING_IN_PROGRESS
        } else {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            audioRecordingLabel.text = TAP_TO_RECORD
        }
    }
}
