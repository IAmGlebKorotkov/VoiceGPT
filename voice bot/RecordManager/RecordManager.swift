//
//  RecordManager.swift
//  voice bot
//
//  Created by Gleb Korotkov on 20.12.2024.
//

import AVFoundation

class RecordManager {
    
    private var recorder: AVAudioRecorder?
    private var timer: Timer?
    init(){
        setupRecorder()
    }

    private func setupRecorder(){
        //1 save
        let audioFileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recording.m4a")
        
        let settings = [
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            
        ]
        do{
            recorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            
            recorder?.record()
            recorder?.stop()
        } catch {
            print("recorder Init error \(error)")
        }
    }
    
    
    func startRecording(){
        recorder?.prepareToRecord()
        recorder?.record()
        startMonitoring()
        
    }
    
    func stopRecording(){
        recorder?.stop()
        stopMonitoring()
        //reset timer
    }
    
    private func startMonitoring(){
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateVolume), userInfo: nil, repeats: true)
    }
    
    private func stopMonitoring(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func updateVolume(){
        recorder?.updateMeters()
        let volume = (recorder?.averagePower(forChannel: 0)) ?? 0
        print(volume)
    }
}
