// Copyright 2013-present Facebook. All Rights Reserved.

import Foundation

class ImageStreamer : NSObject {
    let url: URL
    var session: URLSession!
    var task: URLSessionStreamTask?

    convenience init(url: URL) {
        self.init(url: url, configuration: URLSessionConfiguration.default)
    }

    init(url: URL, configuration: URLSessionConfiguration) {
        self.url = url
        super.init()
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    func connect() {
        assert(self.task == nil)

        let host = "localhost"
        let path = "/image.jpgxxx"

        let task = session.streamTask(withHostName: host, port: 3000)
        task.resume()
        let requestData = """
        GET \(path)


        """.data(using: .ascii)!
        print("""
            GET \(path)


            """)
        task.write(requestData, timeout: 0.01) { (error) in
            print("error: \(error)")
        }
        self.task = task
    }

    func disconnect() {

    }
}

extension ImageStreamer : URLSessionStreamDelegate {
}
