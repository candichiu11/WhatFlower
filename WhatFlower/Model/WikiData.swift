//
//  WikiData.swift
//  WhatFlower
//
//  Created by Candi Chiu on 09.02.22.
//

import Foundation

struct WikiData: Codable {
    let query: Query
}

struct Query: Codable {
    let pageids: [String]
    let pages: [String: Pages]
}

struct Pages: Codable {
    let extract: String
  //  let thumbnail: Thumbnail
}

//struct Thumbnail: Codable {
//    let source: String
//}
