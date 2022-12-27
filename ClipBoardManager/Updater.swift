//
//  Updater.swift
//  ClipBoardManager
//
//  Created by Lennard on 27.12.22.
//

import Foundation
import ZIPFoundation
import AppKit

class Updater {
    let user: String
    let repo: String
    let name: String
    
    init(user: String, repo: String, name: String) {
        self.user = user
        self.repo = repo
        self.name = name
    }
    
    private func shell(command: String) {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", command]
        task.launch()
    }
    
    func checkForUpdate() {
        
    }
    
    func updateApp() {
        fetchUpdateURL()
    }
    
    private func install() {
        let pid = getpid()
        if let to = Bundle.main.resourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent() {
            let wd = to.absoluteURL.path(percentEncoded: false)
            //TODO: remove delay
            shell(command: "sleep 3; kill \(pid); cd \"\(wd)\";rm -rf \"./\(self.name)\"; mv \"./new/\(self.name)\" ./; \"./\(self.name)/Contents/MacOS/ClipBoardManager\"; rm -rf ./new")
        }
    }
    
    private func fetchUpdateURL() {
        //TODO: error handling
        let url = URL(string: "https://api.github.com/repos/\(user)/\(repo)/releases/latest")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let assets = dict?["assets"] as? [[String : Any]]
            if let downloadURLString = assets?[1]["browser_download_url"] as? String {
                if let downloadURL = URL(string: downloadURLString) {
                    self.downloadUpdate(downloadURL: downloadURL)
                }
            }
        }
        task.resume()
    }

    private func downloadUpdate(downloadURL: URL) {
        //TODO: error handling
        let task = URLSession.shared.dataTask(with: downloadURL) {(data, response, error) in
            if data == nil {
                return
            }
            let newVersionZIP = Archive(data: data!, accessMode: .read)
            if newVersionZIP == nil {
                return
            }
            if let to =  Bundle.main.resourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("new") {
                do {
                    //TODO: maybe dont use new dir
                    // check if already exists
                    try FileManager().createDirectory(at: to, withIntermediateDirectories: true)
                } catch {
                    print(error)
                }
                //TODO: track progress
                newVersionZIP?.makeIterator().forEach({e in
                    if e.path.contains("__MACOSX") {
                        return
                    }
                    do {
                        try newVersionZIP?.extract(e, to: URL(string: e.path, relativeTo: to)!)
                    } catch {
                    }
                })
            }
            //TODO: wait for completion
            sleep(5)
            self.install()
        }
        task.resume()
    }
}
