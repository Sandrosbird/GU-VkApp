//
//  RealmService.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 27.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

class RealmService {
    
    static let shared = RealmService()
    private init?(){
        let realmConfig = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: realmConfig) else { return nil }
        
        self.realm = realm
        
        print(realm.configuration.fileURL ?? "")
    }
    
    private let realm: Realm
    
    // MARK: Methods for working with Realm DataBase
    
    func addSingleObject<T: Object>(object: T) throws {
        try realm.write{
            realm.add(object)
        }
    }
    
    func addManyObjects<T: Object>(objects: [T]) throws {
        try realm.write{
            realm.add(objects, update: .modified)
        }
    }
    
    func getFromRealm<T: Object>() -> Results<T> {
        return realm.objects(T.self)
    }
    
    func deleteSingleObject<T: Object>(object: T) throws {
        try realm.write{
            realm.delete(object)
        }
    }
    
    func deleteAll() throws {
        try realm.write{
            realm.deleteAll()
        }
    }
    
    func refillRealmBase<T: Object>(object: T) throws {
        try? deleteSingleObject(object: object)
        try? addSingleObject(object: object)
    }
}
