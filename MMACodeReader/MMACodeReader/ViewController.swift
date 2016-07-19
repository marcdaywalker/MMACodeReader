//
//  ViewController.swift
//  MMACodeReader
//
//  Copyright © 2016 MMApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var reader: MMACodeReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let reader = MMACodeReader(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 100)))
        reader.delegate = self
        view.addSubview(reader)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: MMACodeReaderDelegate {
    func reader(reader: MMACodeReader, didRead value: String) {
        print("URL detected: \(value)")
    }
    
    func readerDidFailRead(reader: MMACodeReader) {
        print("Reading code failed")
    }
    
    func readerDidRejectAccess(reader: MMACodeReader) {
        print("Access to camera rejected")
    }
}