//
//  webViewController.swift
//  Lighting Control App Prototype 1.5
//
//  Created by Cornelius Yap on 26/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import UIKit
import WebKit

class webViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string:"http://192.168.2.146:8000")
        let request = URLRequest(url: url!)
        webViewer.load(request)

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var webViewer: WKWebView!
    

}
