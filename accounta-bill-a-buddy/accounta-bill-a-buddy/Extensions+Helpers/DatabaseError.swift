//
//  DatabaseError.swift
//  accounta-bill-a-buddy
//
//  Created by Cynthia Nikolai on 6/24/21.
//

import Foundation

enum DatabaseError: LocalizedError {
    case fireError(Error)
    case couldNotUnwrap
    case unspecifiedError
    
    var errorDescription: String {
        switch self {
        case .unspecifiedError:
            return "unspecified error"
        case .fireError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "We were unable to get an Item from the data found."
        }
    }
}
