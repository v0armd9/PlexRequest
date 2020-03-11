//
//  YTPlayerViewController.swift
//  Plex Request
//
//  Created by Marcus Armstrong on 12/31/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YTPlayerViewController: UIViewController {

    @IBOutlet var playerView: YTPlayerView!
    
    var videoID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.load(withVideoId: videoID)
    }
}
