//
//  GCDBlackBox.swift
//  FlashcardHero
//
//  Derrived from work Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//
//  Further devlopment by Jacob Foster Davis in August - September 2016

import Foundation

struct GCDBlackBox {
    
    static func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
        
        
    }
    
    static let dataDownload = DispatchQueue(label: "dataDownload", attributes: [])
    
    static func dataDownloadInBackground(_ function: @escaping () -> Void) {
        dataDownload.async {
            function()
        }
    }
    
    static let genericNetworkQueue = DispatchQueue(label: "genericNetworkQueue", attributes: [])
    
    static func runNetworkFunctionInBackground(_ function: @escaping () -> Void) {
        genericNetworkQueue.async {
            function()
        }
    }
    
}
