//
//  SpeechRecognizerViewController.swift
//  Speech Recognizer
//
//  Created by Liam Flaherty on 1/31/19.
//  Copyright © 2019 Liam Flaherty. All rights reserved.
//

import UIKit
import Speech

class SpeechRecognizerViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var speechBtn: UIButton!
    
    @IBOutlet weak var speechLabel: UILabel!
    
    var isRec = false
    let avEngine = AVAudioEngine()
    //can return nill so this must be failable
    //identifies English US only
    let speechRecogn : SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var speechTask : SFSpeechRecognitionTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func speechActionBtn(_ sender: Any) {
        if(!isRec){
            recordAndRecognize()
        }
        else{
            endRec()
            speechLabel.text = "Rec stopped"
        }
    }
    
    func recordAndRecognize(){
        let node = avEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {buffer, _ in self.request.append(buffer)
        }
        avEngine.prepare()
        do{
            try avEngine.start()
            }catch{
                return print(error)
        }
        guard let spchRecog = SFSpeechRecognizer() else{
            print("Speech Recognizer not initialized correctly")
            return
        }
        if !spchRecog.isAvailable{
            print("Speech Recognizer is not available")
            return
        }
        speechTask = speechRecogn?.recognitionTask(with: request, resultHandler: {result, error in
            self.isRec = true
            if let result = result{
                //change label here!
                self.speechLabel.text = result.bestTranscription.formattedString
            } else if let error = error{
                print(error)
            }
        })
    }
    
    func endRec(){
        avEngine.stop()
        request.endAudio()
        let node = avEngine.inputNode
        node.removeTap(onBus: 0)
        speechTask?.cancel()
        isRec = false
    }


}
