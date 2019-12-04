//
//  ViewController.swift
//  3d_gesture_storyboard
//
//  Created by Jinwon on 2019/12/04.
//  Copyright © 2019 Jinwon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    var engine : AVAudioEngine!
    var tone : AVTonePlayerUnit!
    var recordingSession : AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    var audioSession = AVAudioSession.sharedInstance()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tone = AVTonePlayerUnit()
        try! audioSession.setCategory(AVAudioSession.Category.multiRoute)
        try! audioSession.setActive(true)
        tone.frequency = 2000
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        engine = AVAudioEngine()
        engine.attach(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to:mixer, format : format)
        do{
            try engine.start()
        } catch let error as NSError{
            print(error)
        }

    }

    func toneGenerate(){
        if tone.isPlaying{
            engine.mainMixerNode.volume = 0.0
            tone.stop()
            engine.reset()
        }
        else {
            tone.preparePlaying()
            tone.play()
            engine.mainMixerNode.volume = 1.0
        }
    }
    
    func startRecording(){
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try! audioSession.setActive(true)
        audioSession.requestRecordPermission({(allowed: Bool) -> Void in print("Accepted")} )
        
        let currentTime = NSDate()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = format.string(from: currentTime as Date)
        let audioFilename = getDocumentsDirectory().appendingPathComponent(time+".wav")
        
        let settings = [
            AVFormatIDKey : Int(kAudioFormatLinearPCM),
            AVSampleRateKey : 44100,
            AVNumberOfChannelsKey : 1,
            AVLinearPCMBitDepthKey : 16,
            AVLinearPCMIsFloatKey : false,
            AVLinearPCMIsBigEndianKey : false,
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
            ] as [String : Any]
        
        do{
            audioRecorder = try AVAudioRecorder(url:audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch{
            finishRecording(success : false)
        }
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for:.documentDirectory, in : .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(success:Bool){
        audioRecorder.stop()
        audioRecorder = nil
    }

    @IBAction func generate(_ sender: Any) {
            toneGenerate()
    }
    
    @IBAction func record(_ sender: Any) {
        startRecording()

        finishRecording(success: true)
    }
    
}

