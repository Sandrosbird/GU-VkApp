//
//  PhotoCacheService.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 06.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

extension PhotoCacheService {
    
    class Table: DataReloadable {
        let table: UITableView
        
        init(table: UITableView){
            self.table = table
        }
        
        func reloadRow(at indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    class Collection: DataReloadable {
        let collection: UICollectionView
        
        init(collection: UICollectionView){
            self.collection = collection
        }
        
        func reloadRow(at indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
    
}

