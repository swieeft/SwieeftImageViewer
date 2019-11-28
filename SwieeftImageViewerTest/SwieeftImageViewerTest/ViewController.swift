//
//  ViewController.swift
//  SwieeftImageViewerTest
//
//  Created by Park GilNam on 28/11/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var imageViewer: SwieeftImageViewer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_:)))
        imageView1.isUserInteractionEnabled = true
        imageView1.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_:)))
        imageView2.isUserInteractionEnabled = true
        imageView2.addGestureRecognizer(tap2)
        
        imageViewer = SwieeftImageViewer(parentView: self.view)
    }

    @objc func tapImageView(_ sender: UITapGestureRecognizer) {
        
        if let imageView = sender.view as? UIImageView {
            imageViewer.show(originImageView: imageView, contentsText: textField.text)
        }
    }
}

