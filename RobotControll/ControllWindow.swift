// Copyright 2013-present Facebook. All Rights Reserved.

import Cocoa

class ControllWindow: NSWindow, NSWindowDelegate {
    let controll: RobotControll
    @IBOutlet weak var statusField: NSTextField!
    var timer: Timer!
    let streamer: ImageStreamer

    var connected = false {
        didSet {
            if oldValue != connected {
                statusField.stringValue = connected ? "Connected 🚗" : "Disconnected ❌"
            }
        }
    }

    var currectDirection = RobotControll.Direction.stop {
        didSet {
            if (currectDirection != oldValue) {
                print("new direction: \(currectDirection)")
                controll.send(direction: currectDirection)
            }
        }
    }

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        controll = RobotControll(address: "192.168.0.44")
        streamer = ImageStreamer(url: URL(string: "http://localhost:3000/image.jpg")!)
        streamer.connect()
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        self.delegate = self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        connect()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(connect), userInfo: nil, repeats: true)
    }

    @objc func connect() {
        if (!connected) {
            statusField.stringValue = "Connecting..."
            connected = controll.client.connect(timeout: 1).isSuccess
        }
    }

    func direction(key: String) -> RobotControll.Direction? {
        let keys: [String:RobotControll.Direction] =
            ["q": .northWest, "w": .north, "e": .northEast,
             "a": .west,                   "d": .east,
             "z": .southWest, "x": .south, "c": .southEast]

        return keys[key]
    }

    override func keyDown(with event: NSEvent) {
        if (event.modifierFlags.rawValue != 256) {
            return
        }

        guard let characters = event.characters else {
            return
        }

        if let direction = direction(key: characters) {
            currectDirection = direction
        }
    }

    override func keyUp(with event: NSEvent) {
        if (event.modifierFlags.rawValue != 256) {
            return
        }

        guard let characters = event.characters else {
            return
        }

        if let direction = direction(key: characters) {
            if direction == currectDirection {
                currectDirection = .stop
            }
        }
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        currectDirection = .stop
        controll.client.close()
        timer.invalidate()
        return true
    }

}
