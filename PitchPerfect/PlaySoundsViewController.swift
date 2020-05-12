//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Hector Dominguez jr on 4/26/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: PlaySoundsViewController IBOutlets
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow, fast, chipmunk, vader, echo, reverb
    }
    
    /*
       Called once the MainView of a PlaySoundsViewController has been loaded.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    /*
     called when the view is about to appear
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    /**
     Plays the appropriate effect sound for the given button pressed
     */
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
            case .slow:
                playSound(rate: 0.5)
            case .fast:
                playSound(rate: 1.5)
            case .chipmunk:
                playSound(pitch: 1000)
            case .vader:
                playSound(pitch: -1000)
            case .echo:
                playSound(echo: true)
            case .reverb:
                playSound(reverb: true)
            }
        configureUI(.playing)
    }

    /**
     Action to be done when the Stop Button is pressed
     */
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }

}
