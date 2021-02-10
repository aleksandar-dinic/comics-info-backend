//
//  SummariesFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol SummariesFactory {
    
    func makeCharacterSummaries<Link: ComicInfoItem>(_ items: [Character], link: Link, count: Int?) -> [CharacterSummary]
    func makeCharacterSummaries<Link: ComicInfoItem>(_ item: Character, link: [Link], count: Int?) -> [CharacterSummary]
    
    func makeSeriesSummaries<Link: ComicInfoItem>(_ items: [Series], link: Link) -> [SeriesSummary]
    func makeSeriesSummaries<Link: ComicInfoItem>(_ item: Series, link: [Link]) -> [SeriesSummary]
    
    func makeComicSummaries<Link: ComicInfoItem>(_ items: [Comic], link: Link) -> [ComicSummary]
    func makeComicSummaries<Link: ComicInfoItem>(_ item: Comic, link: [Link]) -> [ComicSummary]
    
}

extension SummariesFactory {
    
    func makeCharacterSummaries<Link: ComicInfoItem>(_ items: [Character], link: Link, count: Int?) -> [CharacterSummary] {
        items.map { CharacterSummary($0, link: link, count: count) }
    }
    
    func makeCharacterSummaries<Link: ComicInfoItem>(_ item: Character, link: [Link], count: Int?) -> [CharacterSummary] {
        link.map { CharacterSummary(item, link: $0, count: count) }
    }
    
    func makeSeriesSummaries<Link: ComicInfoItem>(_ items: [Series], link: Link) -> [SeriesSummary] {
        items.map { SeriesSummary($0, link: link) }
    }
    
    func makeSeriesSummaries<Link: ComicInfoItem>(_ item: Series, link: [Link]) -> [SeriesSummary] {
        link.map { SeriesSummary(item, link: $0) }
    }
    
    func makeComicSummaries<Link: ComicInfoItem>(_ items: [Comic], link: Link) -> [ComicSummary] {
        items.map { ComicSummary($0, link: link) }
    }
    
    func makeComicSummaries<Link: ComicInfoItem>(_ item: Comic, link: [Link]) -> [ComicSummary] {
        link.map { ComicSummary(item, link: $0) }
    }
        
}
