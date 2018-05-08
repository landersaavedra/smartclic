//
//  Registro.swift
//  MySampleApp
//
//
// Copyright 2018 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.19
//

import Foundation
import UIKit
import AWSDynamoDB

class Registro: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _rEGID: String?
    var _rEGOFF: String?
    var _rEGON: String?
    
    class func dynamoDBTableName() -> String {

        return "comrudyllantoysmartp-mobilehub-576705720-Registro"
    }
    
    class func hashKeyAttribute() -> String {

        return "_rEGID"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_rEGID" : "REGID",
               "_rEGOFF" : "REGOFF",
               "_rEGON" : "REG_ON",
        ]
    }
}
