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
    
    var engine              : AVAudioEngine!
    var recordingSession    : AVAudioSession!
    var audioRecorder       : AVAudioRecorder!
    var tone                : AVTonePlayerUnit!
    var audioSession        = AVAudioSession.sharedInstance()

    var freq : Double = 2000
    var count = 0
    
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var btGenerate: UIButton!
    @IBOutlet weak var btRecord: UIButton!
    
    override func viewDidLoad() {
        
        btRecord.setTitle("Record", for: .disabled)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tone = AVTonePlayerUnit()
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try! audioSession.setActive(true)
        tone.frequency = freq
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
            btGenerate.setTitle("Generate", for: .normal)
            btRecord.setTitle("Recording...", for: .normal)
            
            engine.mainMixerNode.volume = 0.0
            tone.stop()
            engine.reset()
        }
        else {
            
            tone.preparePlaying()
            tone.play()
            engine.mainMixerNode.volume = 1.0
            
            btGenerate.setTitle("Stop Generate", for: .normal)
            btRecord.setTitle("Stop Record", for: .normal)
        }
    }
    
    func startRecording(){
        
        audioSession.requestRecordPermission({(allowed:Bool) -> Void in print("Accepted")})
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
        count += 1
        state.text = String(count)
    }
    
    
    @IBAction func btG(_ sender: UIButton) {
        toneGenerate()
        state.text = "Button Pressed"
        print("Button Pressed")
    }
    
    @IBAction func btR(_ sender: UIButton) {
        for count in 1 ... 5 {
            print(count)
            sleep(1)
            state.text = "Recording..."
            startRecording()
            print("Recording Start")

            sleep(3)
            state.text = "Preparing"
            finishRecording(success: true)
            print("Record Finish")
            
//            let rduration = DispatchTime.now() + .seconds(1)
//            DispatchQueue.global().sync {
//                self.state.text = "Recording"
//                self.startRecording()
//                print("Recording Start")
//            }
//            sleep(3)
//            let fduration = DispatchTime.now() + .seconds(3)
//            DispatchQueue.global().sync {
//                self.finishRecording(success: true)
//                self.state.text = "Preparing"
//                print("Record Finish")
//            }
        }
        
    }
    
}

