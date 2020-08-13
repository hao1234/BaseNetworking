//
//  Logger.swift
//  BaseNetworking
//
//  Created by Nguyen Vu Hao on 8/2/20.
//  Copyright © 2020 HaoNV. All rights reserved.
//

import UIKit
import CocoaLumberjack

final public class Logger {
    public class func initialize() {
        
        DDLog.add(DDOSLogger.sharedInstance, with: .all)
        dynamicLogLevel = .all
        if let logger = DDTTYLogger.sharedInstance {
            logger.logFormatter = ConsoleLogFormatter()
            DDLog.add(logger, with: .all)
        }

        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60*60*24) // 24hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        fileLogger.maximumFileSize = .zero
        DDLog.add(fileLogger)
        
        // break file for new day
        guard let logPath = fileLogger.logFileManager.sortedLogFileInfos.first,
            logPath.creationDate.isInSameDay(date: Date()) == false else {
            return
        }
        fileLogger.rollLogFile(withCompletion: nil)
    }
    
    public class func verbose(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                       function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .verbose, file: file, function: function, line: line)
    }
    public class func info(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                    function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .info, file: file, function: function, line: line)
    }
    public class func error(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                     function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .error, file: file, function: function, line: line)
    }
    public class func tcp(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                   function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .tcp, file: file, function: function, line: line)
    }
    public class func vc(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                  function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .vc, file: file, function: function, line: line)
    }
    public class func coredata(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                  function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .coredata, file: file, function: function, line: line)
    }
    public class func request(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                        function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .request, file: file, function: function, line: line)
    }
    public class func file(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                    function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .file, file: file, function: function, line: line)
    }
    public class func http(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                           function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .http, file: file, function: function, line: line)
    }
    public class func printer(_ text: String, _ object: AnyObject? = nil, file: StaticString = #file,
                       function: StaticString = #function, line: UInt = #line) {
        log(text, object:object, flag: .printer, file: file, function: function, line: line)
    }
    
    public class func info(with text: String) {
        Logger.info("\(text)")
    }
    
    private class func log(_ text: String, object: AnyObject? = nil, flag: DDLogFlag, file: StaticString,
                           function: StaticString, line: UInt) {
        
        var message: String
        if let object = object {
            message = "[\(type(of: object))] \(text)"
        } else {
            let fileString = String(describing: file)
            if let basename = NSURL(fileURLWithPath: fileString).deletingPathExtension?.lastPathComponent {
                message = "[\(basename)] \(text)"
            } else {
                message = text
            }
        }
        
        _DDLogMessage(
            message, level: dynamicLogLevel, flag: flag, context: 0,
            file: file, function: function, line: line,
            tag: nil, asynchronous: true, ddlog: DDLog.sharedInstance
        )
    }
}

fileprivate extension DDLogFlag {
    static var tcp       = DDLogFlag(rawValue: 1 << 5)
    static var vc        = DDLogFlag(rawValue: 1 << 6)
    static var coredata  = DDLogFlag(rawValue: 1 << 7)
    static var request   = DDLogFlag(rawValue: 1 << 8)
    static var file      = DDLogFlag(rawValue: 1 << 9)
    static var http      = DDLogFlag(rawValue: 1 << 10)
    static var printer   = DDLogFlag(rawValue: 1 << 11)
}

fileprivate extension DDLogFlag {
    
    var symbol: String {
        switch self {
        case DDLogFlag.error:    return "❗️"
        case DDLogFlag.warning:  return "⚠️"
        case DDLogFlag.info:     return "🔷"
        case DDLogFlag.debug:    return "▫️"
        case DDLogFlag.verbose:  return "▪️"
        case DDLogFlag.tcp:      return "🚕"
        case DDLogFlag.vc:       return "▫️"
        case DDLogFlag.coredata: return "💾"
        case DDLogFlag.request:  return "🚕"
        case DDLogFlag.file:     return "📗"
        case DDLogFlag.http:     return "🚙"
        case DDLogFlag.printer:  return "🖨"
            
        default: return "❔"
        }
    }
}

final fileprivate class ConsoleLogFormatter: NSObject, DDLogFormatter {
    
    var dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
        super.init()
        
        dateFormatter.dateFormat = "HH:mm:ss:SSS"
    }
    
    func format(message logMessage: DDLogMessage) -> String? {
        
        let symbol = logMessage.flag.symbol
        let date = dateFormatter.string(from: logMessage.timestamp)
        let text = logMessage.message
        
        if logMessage.flag == .error {
            let banner = "⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️"
            let header = "[ERROR]\n\n\(banner)\n\(banner)\n⛔️"
            let footer = "⛔️\n\(banner)\n\(banner)\n"
            
            return "\(header)\n\(date) \(symbol) \(text)\n\(footer)"
        } else {
            return "\(date) \(symbol) \(text)"
        }
    }
}
