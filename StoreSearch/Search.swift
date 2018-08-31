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
    private var dataTask: URLSessionDataTask? = nil
    private(set) var state: State = .notSearchedYet
    
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([SearchResult])
    }
    
    enum Category: Int {
        case all = 0
        case music = 1
        case software = 2
        case ebooks = 3
        
        var type: String {
            switch self {
            case .all: return ""
            case .music: return "musicTrack"
            case .software: return "software"
            case .ebooks: return "ebook"
            }
        }
    }
    
    func performSearch(for text: String, category: Category,
                       completion: @escaping SearchComplete) {
        print("Searching...")
        
        if !text.isEmpty {
            
            dataTask?.cancel()
            
            state = .loading
            
            let url = iTunesURL(searchText: text, category: category)
            let session = URLSession.shared
            
            dataTask = session.dataTask(with: url) {
                data, response, error in
                var success = false
                var newState = State.notSearchedYet
                
                if let error = error as NSError?, error.code == -999 {
                    print("ERROR : '\(error)'")
                    return
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        var searchResults = self.parse(data: data)
                        if searchResults.isEmpty {
                            newState = .noResults
                        } else {
                            searchResults.sort(by: <)
                            newState = .results(searchResults)
                        }
                        success = true
                        print("SUCESS")
                    }
                } else {
                    print("FAILURE : '\(response!)'")
                }
                
                DispatchQueue.main.async {
                    self.state = newState
                    completion(success)
                }
            }
            dataTask?.resume()
        }
    }
    
    private func iTunesURL(searchText: String, category: Category) -> URL {
        
        let kind = category.type
        
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
