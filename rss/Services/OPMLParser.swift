//
//  OPMLParser.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/26.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation

enum OPMLParserError: Error {
    case internalError(reason: String)
}

extension OPMLParserError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .internalError(let reason):
            return "Internal unresolved error: \(reason)"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .internalError(let reason):
            return "Unable to recover from an internal unresolved error: \(reason)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .internalError:
            return "If you're seeing this error you probably should open an issue on github"
        }
    }
}

enum OPMLPath: String {
    case opml                   = "/opml"
    case opmlHead               = "/opml/head"
    case opmlHeadTitle          = "/opml/head/title"
    case opmlHeadDateCreated    = "/opml/head/dateCreated"
    case opmlHeadOwnerName      = "/opml/head/ownerName"
    case opmlBody               = "/opml/body"
    case opmlBodyOutline        = "/opml/body/outline"
    case opmlBodyOutlineOutline = "/opml/body/outline/outline"
//    case opmlBodyOutlineText    = "/opml/body/outline/text"
//    case opmlBodyOutlineTitle   = "/opml/body/outline/title"
//    case opmlBodyOutlineHtmlUrl = "/opml/body/outline/htmlUrl"
//    case opmlBodyOutlineXmlUrl  = "/opml/body/outline/xmlUrl"
}

class OPML: NSObject {
    
    class Head: NSObject {
        var title: String?
        var dateCreated: Date?
        var ownerName: String?
    }
    
    class Outline: NSObject {
        var title: String?
        var text: String?
        var htmlUrl: String?
        var xmlUrl: String?
        var version: String?
        var desc: String?
        var type: String?
        
        init(_ attributes: [String: String] = [:]) {
            self.title = attributes["title"]
            self.text = attributes["text"]
            self.htmlUrl = attributes["htmlUrl"]
            self.xmlUrl = attributes["xmlUrl"]
            self.version = attributes["version"]
            self.desc = attributes["description"]
            self.type = attributes["type"]
            super.init()
        }
    }
    
    var head: Head?
    var outlines: [Outline] = []
    
    func map(_ attributes: [String: String], for path: OPMLPath) {
        switch path {
        case .opmlHead:
            self.head = Head()
        case .opmlBody:
            self.outlines = []
        case .opmlBodyOutline,
             .opmlBodyOutlineOutline:
            self.outlines.append(Outline(attributes))
        default: return
        }
    }
    
    func map(_ string: String, for path: OPMLPath) {
        switch path {
        case .opmlHeadTitle:                self.head?.title = string
        case .opmlHeadDateCreated:          self.head?.dateCreated = string.toPermissiveDate()
        case .opmlHeadOwnerName:            self.head?.ownerName = string
        default: return
        }
    }
}

class OPMLParser: NSObject, XMLParserDelegate {
    
    let xmlParser: XMLParser
    
    var opml: OPML?
    
    fileprivate var curXMLDOMPath: URL = URL(string: "/")!
    
    var parsingError: Error?
    var parseComplete = false
    
    required init(data: Data) {
        self.xmlParser = XMLParser(data: data)
        super.init()
        self.xmlParser.delegate = self
    }
    
    func parse() -> Result<OPML, OPMLParserError> {
        let _ = self.xmlParser.parse()
        
        if let error = self.parsingError {
            return .failure(.internalError(reason: error.localizedDescription))
        }
        
        guard let opml = self.opml else {
            return .failure(.internalError(reason: "opml object is nil"))
        }
        
        return .success(opml)
    }
}

extension OPMLParser {
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]) {
        
        self.curXMLDOMPath = self.curXMLDOMPath.appendingPathComponent(elementName)
        
        if self.opml == nil {
            self.opml = OPML()
        }
        print("path = \(self.curXMLDOMPath)")
        if let path = OPMLPath(rawValue: self.curXMLDOMPath.absoluteString) {
            self.opml?.map(attributeDict, for: path)
        }
    }
    
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?) {
        self.curXMLDOMPath = self.curXMLDOMPath.deletingLastPathComponent()
        if self.curXMLDOMPath.absoluteString == "/" {
            self.parseComplete = true
            self.xmlParser.abortParsing()
        }
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        // TODO:
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let path = OPMLPath(rawValue: self.curXMLDOMPath.absoluteString) {
            self.opml?.map(string, for: path)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        // Ignore errors that occur after a feed is successfully parsed. Some
        // real-world feeds contain junk such as "[]" after the XML segment;
        // just ignore this stuff.
        guard !parseComplete, parsingError == nil else { return }
        self.parsingError = parseError
    }
    
}
