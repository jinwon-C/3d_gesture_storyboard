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
    var count = 1
    var gesture = ""
    
    
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var btGenerate: UIButton!
    @IBOutlet weak var btRecord: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
                
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
            audioRecorder = try AVAudioRecorder(url:audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            sleep(3)
            
            audioRecorder.stop()
            audioRecorder = nil
            
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
    
    
    @IBAction func btG(_ sender: UIButton) {
        toneGenerate()
        state.text = "Button Pressed"
        print("Button Pressed")
    }
    
    @IBAction func btR(_ sender: UIButton) {
//        self.btRecord.setTitle("Recording...", for: .disabled)
        
        for _ in 1 ... 2 {
            print(count)
//            sleep(1)
            
//            let queue = DispatchQueue(label : 'jinwon')
            self.state.text = "Recording..."
            print("Recordin Start")
            
            print("Recording...")
//            self.startRecording()
            sleep(3)
//            self.state.text = "Preparing"
            print("Recording Finish")
//            DispatchQueue.main.async {
//
//            }
//            DispatchQueue.main.sync {
//                self.startRecording()
//            }
//            print("Recording Start : ")
//
////            sleep(3)
////            finishRecording(success: true)
//
////            self.state.text = "Preparing"
//            DispatchQueue.main.sync {
//                self.state.text = "Preparing"
//            }
//            print("Record Finish : ")
            //state.text = gesture + String(count)
            self.count += 1
            
            
            
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
        btRecord.setTitle("Record", for: .normal)
    }
    @IBAction func btM(_ sender: Any) {
        self.count = 1
        gesture = textField.text!
        state.text = gesture
    }
    
}

