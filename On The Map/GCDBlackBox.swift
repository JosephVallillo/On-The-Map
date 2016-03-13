//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Joseph Vallillo on 2/28/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}