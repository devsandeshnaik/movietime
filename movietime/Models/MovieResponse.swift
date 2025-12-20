//
//  MovieResponse.swift
//  movietime
//
//  Created by Sandesh Naik on 21/10/25.
//

import Foundation

struct Dates: Codable {
    let maximum: String?
    let minimum: String?
}

struct MovieResponse: Codable {
    let results: [Movie]
    let page: Int
    let total_results: Int
    let dates: Dates?
    let total_pages: Int
}
