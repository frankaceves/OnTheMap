//
//  StudentDataInfo.swift
//  OnTheMap
//
//  Created by Frank Anthony Aceves on 5/21/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import Foundation

var students = [StudentInformation]()


// MARK: Shared Instance

func sharedInstance() -> UdacityClient {
    struct Singleton {
        static var sharedInstance = UdacityClient()
    }
    return Singleton.sharedInstance
}
