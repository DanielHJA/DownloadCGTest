//
//  Request.swift
//  DownloadTest
//
//  Created by Daniel Hjärtström on 2017-07-25.
//  Copyright © 2017 Daniel Hjärtström. All rights reserved.
//

import UIKit

class Request: NSObject, URLSessionDownloadDelegate, URLSessionDelegate {
    
    private var downloadTask: URLSessionDownloadTask?
    
    lazy var urlSession: URLSession = {
    
        var configuration = URLSessionConfiguration.default
        var session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    func JSONRwquest(completion: @escaping (_ result: Dictionary<String,Any>?, _ error: NSError?) -> ()) {
    
    }

    func fetchOperation(){
  
        guard let url = URL(string: "http://download.thinkbroadband.com/200MB.zip") else {
            return
        }
        
        let request = URLRequest(url: url)
        let session = urlSession
        
        downloadTask = session.downloadTask(with: request)
        downloadTask?.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentageWritten = (Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)) * 100
        
        print(percentageWritten)
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(error?.localizedDescription as Any)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error?.localizedDescription as Any)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let filemanager = FileManager.default
        
        guard let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first! else {
            return
        }
      
        print(documentsURL)
        
        guard let response = downloadTask.response else {
            return
        }
        
        let fileDestination = documentsURL.appendingPathComponent((response.suggestedFilename)!)
        print(fileDestination)
        
        if filemanager.fileExists(atPath: fileDestination.path) {
            
            print("File already exist")
       
        } else {
        
            var data: Data = Data()
            
            do {
            
                data = try Data(contentsOf: response.url!)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            do {
            
                try data.write(to: fileDestination)
                
            } catch let error {
                print(error.localizedDescription)
            }
        
            do {
                let attributes: Dictionary? = try FileManager().attributesOfItem(atPath: fileDestination.path)
                
                if let attr = attributes {
                    print(attr)
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        
        }
    }
}
