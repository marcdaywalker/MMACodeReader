# MMACodeReader

Code reader using the camera of the device. It supports ***Universal Product Code***, ***QR Code***, ***Aztec Code***, etc.

## Installation
- **Manual:**
	- Include the file `MMACodeReader.swift` into your project
- **CocoaPods:**
	- `pod MMACodeReader`

## Usage

```Swift
let reader = MMACodeReader(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 100)))
reader.delegate = self
view.addSubview(reader)

//Delegates
func reader(reader: MMACodeReader, didRead value: String) {
    print("URL detected: \(value)")
}
    
func readerDidFailRead(reader: MMACodeReader, error: ErrorType) {
    print("Reading code failed: \(error)")
}
    
func readerDidRejectAccess(reader: MMACodeReader) {
    print("Access to camera 
}
```

## History
- **Version 1.0.0:**
	- First version

## License
The MIT License (MIT)

Copyright (c) 2016 Marcos Martinez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.