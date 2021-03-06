//
//  Audios.swift
//  MGKombatSwift
//
//  Created by Marco Guerrieri on 22/05/18.
//  Copyright © 2017 elipse.it. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

final class Audios: NSObject, AVAudioPlayerDelegate {
    
    enum AudioType : Int {
        case none = -1
        case mainTheme = 0
        case presentation = 1
        case battle = 2
        case win = 3
        case defeat = 4
    }
    
    
    private let mainTheme : [URL] = [
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "create_character", ofType: "mp3")!),
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "arcade_theme", ofType: "mp3")!),
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "8bit_theme", ofType: "mp3")!),
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "elettronica_theme", ofType: "mp3")!),
    ]
    
    private let presentationTheme : [URL] = [
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "drum", ofType: "wav")!),
    ]
    
    private let battleTheme : [URL] = [
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "create_character", ofType: "mp3")!),
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "arcade_theme", ofType: "mp3")!),
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "8bit_theme", ofType: "mp3")!),
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "elettronica_theme", ofType: "mp3")!),
    ]
    
    private let winTheme : [URL] = [
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "ff7victory", ofType: "mp3")!)
    ]
    
    private let defeatTheme : [URL] = [
        URL.init(fileURLWithPath: Bundle.main.path(forResource: "bbdeath", ofType: "mp3")!)
    ]
    
    
    static let shared = Audios()
    
    private var repeatAudio : Bool = false
    private var audioPlayer : AVAudioPlayer?
    private var lastAudioType : AudioType = .none
    private var currentUrl : URL?
    
    public var isPlaying : Bool = false
    
    override init() {
        super.init()
        audioPlayer?.delegate = self
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if self.repeatAudio {
            self.play(audioType: self.lastAudioType, forceChange: false)
        }
    }
    
    private func playAudio(url: URL, repeating: Bool){
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        self.repeatAudio = repeating
        
        self.currentUrl = url
        try! audioPlayer = AVAudioPlayer.init(contentsOf: url)
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
    
    func stopAudio(){
        isPlaying = false
        audioPlayer?.stop()
    }
    
    func pauseAudio(){
        isPlaying = false
        audioPlayer?.pause()
    }
    
    func resumeAudio(){
        isPlaying = true
        audioPlayer?.play()
    }

    func play(audioType: AudioType, forceChange: Bool){
        if !forceChange && audioType == self.lastAudioType &&
            (audioPlayer?.isPlaying)! {
            return
        }
        
        self.lastAudioType = audioType
        audioPlayer?.stop()
        
        switch audioType {
        case .none:
            break
        case .mainTheme:
            self.playMainTheme(random: true)
            break
        case .presentation:
            self.playPresentation()
            break
        case .battle:
            self.playBattle()
            break
        case .win:
            self.playWin()
            break
        case .defeat:
            self.playDefeat()
            break
        }
    }
    
    private func playMainTheme(random: Bool) {
        let url : URL?
        if random {
            let randomChoice = Int(arc4random_uniform(UInt32((self.mainTheme.count))))
            url = self.mainTheme[randomChoice]
        }
        else {
            var currentIdx = 1
            if currentUrl != nil {
                currentIdx = self.mainTheme.index(of: currentUrl!) ?? 1
            }
            if currentIdx == 0 {
                url = self.mainTheme.last
            }
            else if currentIdx == self.mainTheme.count - 1{
                url = self.mainTheme.first
            }
            else {
                url = self.mainTheme[currentIdx]
            }
        }
        self.playAudio(url: url!, repeating: true)
    }
    
    private func playPresentation() {
        let randomChoice = Int(arc4random_uniform(UInt32((self.presentationTheme.count))))
        let randomUrl : URL = self.presentationTheme[randomChoice]
        self.playAudio(url: randomUrl, repeating: false)
    }
    
    private func playBattle() {
        let randomChoice = Int(arc4random_uniform(UInt32((self.battleTheme.count))))
        let randomUrl : URL = self.battleTheme[randomChoice]
        self.playAudio(url: randomUrl, repeating: true)
    }
    
    private func playWin() {
        let randomChoice = Int(arc4random_uniform(UInt32((self.winTheme.count))))
        let randomUrl : URL = self.winTheme[randomChoice]
        self.playAudio(url: randomUrl, repeating: false)
    }
    
    private func playDefeat() {
        let randomChoice = Int(arc4random_uniform(UInt32((self.defeatTheme.count))))
        let randomUrl : URL = self.defeatTheme[randomChoice]
        self.playAudio(url: randomUrl, repeating: false)
    }
    
    func nextSong() {
        self.play(audioType: self.lastAudioType, forceChange: true)
        isPlaying = true
    }
    
    func nextThemeSong() {
        self.play(audioType: .battle, forceChange: true)
        isPlaying = true
    }
    
    func prevThemeSong(){
        self.play(audioType: .battle, forceChange: true)
    }
}
