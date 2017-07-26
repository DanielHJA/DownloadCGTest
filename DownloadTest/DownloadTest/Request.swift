//
//  Request.swift
//  DownloadTest
//
//  Created by Daniel Hjärtström on 2017-07-25.
//  Copyright © 2017 Daniel Hjärtström. All rights reserved.
//

import UIKit

protocol DownloadUpdateProtocol {

    func updateProgress(progress: Double)
    
}

class Request: NSObject, URLSessionDownloadDelegate, URLSessionDelegate {
    
    var delegate: DownloadUpdateProtocol?
    
    private var downloadTask: URLSessionDownloadTask?
    
    private lazy var urlSession: URLSession = {
    
        var configuration = URLSessionConfiguration.default
        var session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    func requestJSONDownload(completion: @escaping (_ result: Dictionary<String,Any>?, _ error: Error?) -> ()) {
    
        guard let url = URL(string: "") else {
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
    
        _ = session.dataTask(with: request) { (responseData, response, error) in
            
            var json: Dictionary<String, Any>?
            
            if let data = responseData, (error == nil) {
                
                do {
                
                    json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                
                } catch let error {
                    print("Error decoding data to JSON: \(error.localizedDescription)")
                }
                
                guard let jsonData = json else {
                    return
                }
                
                completion(jsonData, nil)
                
            } else {
            
                completion(nil, error)
            
            }
            
        }
    }

    func requestFileDownload(){
  
        guard let url = URL(string: "http://download.thinkbroadband.com/200MB.zip") else {
            return
        }
        
        let request = URLRequest(url: url)
        let session = urlSession
        
        downloadTask = session.downloadTask(with: request)
        downloadTask?.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentageWritten: Double = (Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)) * 100
        
        self.delegate?.updateProgress(progress: percentageWritten)
        
      //  print(percentageWritten)
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(error?.localizedDescription as Any)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error?.localizedDescription as Any)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let filemanager = FileManager.default
    
        let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
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
        
            var fileSize : UInt64
            
            do {

                let attr = try FileManager.default.attributesOfItem(atPath: fileDestination.path)
                fileSize = attr[FileAttributeKey.size] as! UInt64
                
                let dict = attr as NSDictionary
                fileSize = dict.fileSize()
                print(fileSize)
          
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
