//
//  SoundManager.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/10.
//  Copyright © 2020 김예빈. All rights reserved.
//

import Foundation
import AVFoundation

final class SoundManager: NSObject, AVAudioPlayerDelegate {

    static let shared: SoundManager = SoundManager()

    private let initialVolumSize: Float = 0.7
    
    private var bakgroundAudioPlayer: AVAudioPlayer?
    
    private var clickEffectAudioPlayer: AVAudioPlayer?
    private var alignedEffectAudioPlayer: AVAudioPlayer?
    private var selectedEffectAudioPlayer: AVAudioPlayer?
    private var moveFailEffectAudioPlayer: AVAudioPlayer?
    private var moveSuccessEffectAudioPlayer: AVAudioPlayer?
    
    private var effectArray: [AVAudioPlayer?] = []

    var backgroundVolumeSize: Float {
        return bakgroundAudioPlayer?.volume ?? initialVolumSize
    }

    var effectVolumeSize: Float {
        return clickEffectAudioPlayer?.volume ?? initialVolumSize
    }

    func registerSound() {
        bakgroundAudioPlayer = nil

        // import시킨 음원에 대한 리소스를 받아옴
        let backgroundUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "BayBreeze", ofType:"wav")!)

        let clickUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "SoundClick", ofType:"wav")!)
        let selectedUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "SoundSelected", ofType:"WAV")!)
        let moveFailUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "SoundMoveFail", ofType:"wav")!)
        let moveSuccessUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "SoundMoveSuccess", ofType:"wav")!)

        // AVAudioPlayer 인스턴스 생성
        do {
            try bakgroundAudioPlayer = AVAudioPlayer(contentsOf: backgroundUrl)

            try clickEffectAudioPlayer  = AVAudioPlayer(contentsOf: clickUrl)
            try selectedEffectAudioPlayer  = AVAudioPlayer(contentsOf: selectedUrl)
            try moveFailEffectAudioPlayer  = AVAudioPlayer(contentsOf: moveFailUrl)
            try moveSuccessEffectAudioPlayer  = AVAudioPlayer(contentsOf: moveSuccessUrl)

            effectArray.append(clickEffectAudioPlayer)
            effectArray.append(selectedEffectAudioPlayer)
            effectArray.append(moveFailEffectAudioPlayer)
            effectArray.append(moveSuccessEffectAudioPlayer)

            if bakgroundAudioPlayer == nil {
                print("audioPlayer error")
            } else {
                bakgroundAudioPlayer?.prepareToPlay()

                for i in 0 ... 3 {
                    effectArray[i]?.prepareToPlay()
                }
            }
        } catch {
            print("Error ==> \(error)")
        }

        // 반복재생
        bakgroundAudioPlayer?.numberOfLoops = -1
        bakgroundAudioPlayer?.volume = initialVolumSize

        for effect in effectArray {
            effect?.volume = initialVolumSize
        }

        if let player = bakgroundAudioPlayer {
            player.play()
        }
    }
    
    func playClickEffect() {
        clickEffectAudioPlayer?.play()
    }
    
    func adjustBackgroundVolume(_ value: Float) {
        bakgroundAudioPlayer?.volume = value
    }
    
    func adjustEffectVolume(_ value: Float) {
        for effect in effectArray {
            effect?.volume = value
        }
    }
    
}
