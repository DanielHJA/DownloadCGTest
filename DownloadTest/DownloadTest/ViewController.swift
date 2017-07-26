//
//  ViewController.swift
//  DownloadTest
//
//  Created by Daniel Hjärtström on 2017-07-25.
//  Copyright © 2017 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DownloadUpdateProtocol {

    @IBOutlet weak var loadingView: ProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        loadingView.initiateDownload()
        let req = Request()
        req.delegate = self
        req.requestFileDownload()
    }
    
    func updateProgress(progress: Double) {
        
        self.loadingView.updateStroke(progress: CGFloat(progress / 100))
        
        DispatchQueue.main.async {
            self.percentageLabel.text = String(format: "%.1f%", progress)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

