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
    
    func readerDidFailRead(reader: MMACodeReader, error: ErrorType) {
        print("Reading code failed: \(error)")
    }
    
    func readerDidRejectAccess(reader: MMACodeReader) {
        print("Access to camera rejected")
    }
}