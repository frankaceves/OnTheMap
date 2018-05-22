//
//  StudentDataInfo.swift
//  OnTheMap
//
//  Created by Frank Anthony Aceves on 5/21/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import Foundation

class StudentDataInfo: NSObject {
    var students = [StudentInformation]()


    // MARK: Shared Instance

    class func sharedInstance() -> StudentDataInfo {
        struct Singleton {
            static var sharedInstance = StudentDataInfo()
        }
        return Singleton.sharedInstance
    }
}
