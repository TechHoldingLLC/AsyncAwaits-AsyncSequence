//
//  AsyncSequence.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 13/02/23.
//

import Foundation
import UIKit

struct DataSequence: AsyncSequence {
    typealias Element = Data
    let urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
    }
    
    func makeAsyncIterator() -> DataIterator {
        return DataIterator(urls: urls)
    }
    
}

struct DataIterator: AsyncIteratorProtocol{
    typealias Element = Data
    
    let urls: [URL]
    private var index = 0
    private var urlsession = URLSession.shared
    
    init(urls: [URL]) {
        self.urls = urls
    }
    
    mutating func next() async throws -> Data? {
        guard index < urls.count else{
            return nil
        }
        
        let url = urls[index]
        index += 1
        
        let (data, _) = try await urlsession.data(from: url)
        
        return data
    }
    
}
