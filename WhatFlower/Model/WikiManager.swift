//
//  WikiManager.swift
//  WhatFlower
//
//  Created by Candi Chiu on 09.02.22.
//

import Foundation

protocol wikiManagerDelegate {
    func didUpdateLabel(_ wikiManager: WikiManager, extract: WikiModel)
    func didFailWithError(error: Error)
}


struct WikiManager {
    let wikipediaURL = "https://en.wikipedia.org/w/api.php?"

    var delegate: wikiManagerDelegate?
    
    func fetchContent(flowerName: String) {
        let checkedFlowerName: String
        
        if flowerName.contains(" ") {
            checkedFlowerName = flowerName.replacingOccurrences(of: " ", with: "%20")
        } else {
            checkedFlowerName = flowerName
        }
        
        let urlString = "\(wikipediaURL)format=json&action=query&prop=extracts&exintro&explaintext&titles=\(checkedFlowerName)&indexpageids&redirects=1"
      
        print(urlString)
        
        performRequest(with: urlString)
    }
    
   func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let extract = self.parseJSON(safeData) {
                        delegate?.didUpdateLabel(self, extract: extract)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ wikiData: Data) -> WikiModel? {
      let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WikiData.self, from: wikiData)
            let id = decodedData.query.pageids[0]
            let extract = decodedData.query.pages[id]?.extract
            print(extract!)
           // let wikiPictureURL = decodedData.query.pages[id]?.thumbnail.source
            let wikiModel = WikiModel(extract: extract!)
            return wikiModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
