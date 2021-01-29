//
//  SummariesFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol SummariesFactory {
    
    func makeCharacterSummaries<Link: ComicInfoItem>(_ items: [Character], link: Link, count: Int?) -> [CharacterSummary<Link>]
    func makeCharacterSummaries<Link: SummaryMapper>(_ item: Character, link: [Link], count: Int?) -> [CharacterSummary<Link>]
    
    func makeSeriesSummaries<Link: ComicInfoItem>(_ items: [Series], link: Link) -> [SeriesSummary<Link>]
    func makeSeriesSummaries<Link: SummaryMapper>(_ item: Series, link: [Link]) -> [SeriesSummary<Link>]
    
    func makeComicSummaries<Link: ComicInfoItem>(_ items: [Comic], link: Link, number: String?) -> [ComicSummary<Link>]
    func makeComicSummaries<Link: SummaryMapper>(_ item: Comic, link: [Link], number: String?) -> [ComicSummary<Link>]
    
}

extension SummariesFactory {
    
    func makeCharacterSummaries<Link: ComicInfoItem>(_ items: [Character], link: Link, count: Int?) -> [CharacterSummary<Link>] {
        items.map { CharacterSummary($0, id: link.id, link: Link.self, count: count) }
    }
    
    func makeCharacterSummaries<Link: SummaryMapper>(_ item: Character, link: [Link], count: Int?) -> [CharacterSummary<Link>] {
        link.map { CharacterSummary(item, id: $0.id, link: Link.self, count: count) }
    }
    
    func makeSeriesSummaries<Link: ComicInfoItem>(_ items: [Series], link: Link) -> [SeriesSummary<Link>] {
        items.map { SeriesSummary($0, id: link.id, link: Link.self) }
    }
    
    func makeSeriesSummaries<Link: SummaryMapper>(_ item: Series, link: [Link]) -> [SeriesSummary<Link>] {
        link.map { SeriesSummary(item, id: $0.id, link: Link.self) }
    }
    
    func makeComicSummaries<Link: ComicInfoItem>(_ items: [Comic], link: Link, number: String?) -> [ComicSummary<Link>] {
        items.map { ComicSummary($0, id: link.id, link: Link.self, number: number) }
    }
    
    func makeComicSummaries<Link: SummaryMapper>(_ item: Comic, link: [Link], number: String?) -> [ComicSummary<Link>] {
        link.map { ComicSummary(item, id: $0.id, link: Link.self, number: number) }
    }
        
}
