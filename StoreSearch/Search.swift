//
//  Search.swift
//  StoreSearch
//
//  Created by Aurélien Schneberger on 29/08/2018.
//  Copyright © 2018 Aurélien Schneberger. All rights reserved.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

class Search {
    var searchResults: [SearchResult] = []
    var hasSearched = false
    var isLoading = false
    private var dataTask: URLSessionDataTask? = nil
    
    func performSearch(for text: String, category: Int,
                       completion: @escaping SearchComplete) {
        print("Searching...")
        
        if !text.isEmpty {
            
            dataTask?.cancel()
            
            isLoading = true
            hasSearched = true
            searchResults = []
            
            let url = iTunesURL(searchText: text, category: category)
            let session = URLSession.shared
            
            dataTask = session.dataTask(with: url) {
                data, response, error in
                var success = false
                if let error = error as NSError?, error.code == -999 {
                    print("ERROR : '\(error)'")
                    return
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        self.searchResults.sort(by: <)
                        self.isLoading = false
                        success = true
                        print("SUCESS")
                    }
                } else {
                    print("FAILURE : '\(response!)'")
                }
                
                if !success {
                    self.hasSearched = false
                    self.isLoading = false
                }
                DispatchQueue.main.async {
                    completion(success)
                }
            }
            dataTask?.resume()
        }
    }
    
    private func iTunesURL(searchText: String, category: Int) -> URL {
        
        let kind: String
        switch category {
        case 1:
            kind = "musicTrack"
        case 2:
            kind = "software"
        case 3:
            kind = "ebook"
        default:
            kind = ""
        }
        
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=%@", encodedText, kind)
        let url = URL(string: urlString)
        
        return url!
    }
    
    
    private func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(resultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}
