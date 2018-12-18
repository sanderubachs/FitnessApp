//
//  Post.swift
//  BijlessApp
//
//  Created by issd on 13/12/2018.
//  Copyright © 2018 Fontys. All rights reserved.
//

class Post{
    
    var id: String?
    var onderwerp: String?
    var naam: String?
    var beschrijving: String?
    var datum: String?
    var taal: String?
    
    init(id: String?, onderwerp: String?, naam: String?, beschrijving: String?, datum: String?, taal: String?){
        self.id = id;
        self.onderwerp = naam;
        self.naam = onderwerp;
        self.beschrijving = beschrijving;
        self.datum = datum;
        self.taal = taal;
    }
}
