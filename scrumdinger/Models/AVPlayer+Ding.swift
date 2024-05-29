//
//  AVPlayer+Ding.swift
//  scrumdinger
//
//  Created by Calum Crawford on 5/17/24.
//

import Foundation
import AVFoundation

enum AVPlayerError: Error, LocalizedError {
    case resourceNotFound(resource: String, resourceExtension: String)
    
    var errorDescription: String? {
        switch self {
        case .resourceNotFound(let resource, let resourceExtension):
            return "Failed to find \(resource).\(resourceExtension) sound file."
        }
    }
}

extension AVPlayer {
    static func customPlayer(resource: String, resourceExtension: String) throws -> AVPlayer {
        guard let url = Bundle.main.url(forResource: resource, withExtension: resourceExtension) else {
            return AVPlayerError.resourceNotFound(resource: resource, resourceExtension: resourceExtension) as! AVPlayer
        }
        return AVPlayer(url: url)
    }
}

