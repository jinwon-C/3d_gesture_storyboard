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

    var freq : Double = 20000
    var count = 0
    var gesture = ""
    var timer:Timer?
    
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var btGenerate: UIButton!
    @IBOutlet weak var btRecord: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
                
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tone = AVTonePlayerUnit()
        tone.frequency = freq
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try! audioSession.setActive(true)
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
            
            engine.mainMixerNode.volume = 0.0
            tone.stop()
            engine.reset()
        }
        else {
            
            tone.preparePlaying()
            tone.play()
            engine.mainMixerNode.volume = 1.0
            
            btGenerate.setTitle("Stop Generate", for: .normal)
           
        }
    }
    
    @objc func startRecording(){
        count += 1
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try! audioSession.setActive(true)
        audioSession.requestRecordPermission({(allowed: Bool) -> Void in print("Accepted")} )
        
        let currentTime = NSDate()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = format.string(from: currentTime as Date)
        let audioFilename = getDocumentsDirectory().appendingPathComponent(gesture+String(count)+" "+time+".wav")
        
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
            print(getDocumentsDirectory())
            audioRecorder = try AVAudioRecorder(url:audioFilename, settings: settings)
            audioRecorder.delegate = self
//                self.state.text = String(String(self.count)+" Start")
            
            print("Recording Start")
            print("Recording Start")
            print("Recording Start")
            print("Recording Start")
            print("Recording Start")
            self.audioRecorder.record(forDuration: 3)
            sleep(3)
            
            self.state.text = String(String(self.count)+" Prepare")

            print("Recording Finish")
            print("Recording Finish")
            print("Recording Finish")
            print("Recording Finish")
            print("Recording Finish")

        } catch{
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for:.documentDirectory, in : .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func btG(_ sender: UIButton) {
        toneGenerate()
        state.text = "Button Pressed"
        print("Button Pressed")
    }
    
    func startTimer(){
        self.timer = Timer.scheduledTimer(timeInterval : 4, target: self, selector: #selector(startRecording), userInfo: nil, repeats: true)
    }
    
    @IBAction func btR(_ sender: UIButton) {
        startTimer()
    }
    
    @IBAction func btM(_ sender: Any) {
        self.count = 0
        gesture = textField.text!
        state.text = gesture
        timer?.invalidate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
}

