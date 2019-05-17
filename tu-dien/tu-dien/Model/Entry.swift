//
//  Entry.swift
//  tu-dien
//
//  Created by BtoW on 1/20/19.
//

import Foundation

class Entry {
    var title: String
    var content: String
    
    init(_ title: String, content: String) {
        self.title = title
        self.content = content
        
    }
}

struct Sentences: Codable {
    let trans: String
    let orig: String
}

struct TranslationObject: Codable {
    let sentences: [Sentences]
}
