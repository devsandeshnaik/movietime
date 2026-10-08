//
//  Constants.swift
//  movietime
//
//  Created by Sandesh Naik on 16/08/25.
//

import Foundation

struct NetworkConstants {
    static let baseURL = "https://api.themoviedb.org/3/"
    
    static var apiKeyString: String {
        "?api_key=\(tmdbAPIKey)"
    }
    
    static let imageURl = "https://image.tmdb.org/t/p/original"
    
    // MARK: - Private Helpers
    
    /// Reads TMDb API Key from AppKeys.plist
    private static var tmdbAPIKey: String {
        guard let path = Bundle.main.path(forResource: "appkeys", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let apiKey = dict["TMDb_API_Key"] as? String else {
            fatalError("TMDb_API_Key not found in AppKeys.plist. Make sure the file exists and contains the key.")
        }
        return apiKey
    }
}
