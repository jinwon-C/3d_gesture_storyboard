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
    
    var recordingSession : AVAudioSession!
    var audioRecorder : AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        startRecording()
    }
    
    @IBAction func record(_ sender: Any) {
        finishRecording(success: true)
    }
    
}

