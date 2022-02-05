//
//  DomainComicSummary+MyComic.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import struct Domain.ComicSummary
import Foundation

extension Domain.ComicSummary {
    
    init(from myComic: MyComic) {
        self.init(
            identifier: myComic.comicID,
            popularity: myComic.popularity,
            title: myComic.title,
            thumbnail: myComic.thumbnail,
            description: myComic.description,
            number: myComic.number,
            published: myComic.published
        )
    }
    
}
