//
//  Connectivity.swift
//  TopMovies
//
//  Created by panandafog on 23.04.2021.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
