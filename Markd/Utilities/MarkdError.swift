//
//  MarkdError.swift
//  Markd
//
//  Created by Joshua Schmidt on 10/14/18.
//  Copyright © 2018 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation

public enum MarkdError:Error {
    case UnknownFileContentType
    case UnexpectedNil
    case UnsupportedConfiguration
    case HttpError
    case NotificationError
}
