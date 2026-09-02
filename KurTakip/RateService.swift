//
//  Untitled.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 1.09.2026.
//

import Foundation

struct RateService {
    func fetchRates() async throws -> [Rate] {
        let url = URL(string: "https://www.tcmb.gov.tr/kurlar/today.xml")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse,
              http.statusCode == 200 else{
            throw URLError(.badServerResponse)
        }
        
        let rates = RateParser().parse(data)
        guard !rates.isEmpty else {
            throw URLError(.badServerResponse)
        }
        
        return rates
       
    }
}

final class RateParser: NSObject, XMLParserDelegate {

    private var rates: [Rate] = []
    private var buffer = ""
    private var code = ""
    private var unit = 1
    private var selling: Double?

    func parse(_ data: Data) -> [Rate] {
        rates = []
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        print("Parser \(rates.count) kur buldu")
        return rates
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        buffer = ""

        if elementName == "Currency" {
            code = attributeDict["CurrencyCode"] ?? ""
            unit = 1
            selling = nil
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        buffer += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        let value = buffer.trimmingCharacters(in: .whitespacesAndNewlines)

        switch elementName {
        case "Unit":
            unit = Int(value) ?? 1
        case "ForexSelling":
            selling = Double(value)
        case "Currency":
            if let selling {
                rates.append(Rate(code: code, selling: selling / Double(unit)))
            }
        default:
            break
        }

        buffer = ""
    }
}
