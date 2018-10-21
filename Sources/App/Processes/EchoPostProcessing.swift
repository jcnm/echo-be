//
//  EchoPostProcessing.swift
//  App
//
//  Created by J. Charles N. M. on 23/09/2018.
//

import Foundation
import FluentSQLite
import Vapor

public final class EchoPostProcessing  {

    public static func newEchoProcessing(echo: Echo, from request: Vapor.Request) {
        let bckgQueue = DispatchQueue.global()
        print("Ready to send in the background ", request.eventLoop, " Queue: ", bckgQueue.label)
        bckgQueue.async  {
            /// Puts the background thread to sleep
            /// This will not affect any of the event loops
            print("Dans le backgroound ", bckgQueue)
            sleep(5)
            let _ = User.query(on: request)
            .filter(\User.id, SQLiteBinaryOperator.equal, echo.author)
                .all().map({ (users) -> Void in
                    users.forEach{print("User found ", $0.email) }
                })
            sleep(10)
            /// When the "blocking work" has completed,
            /// complete the promise and its associated future.
            print("Echo was well processing")
        }
    }
    
}
