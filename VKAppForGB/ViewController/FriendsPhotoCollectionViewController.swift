//
//  FriendsPhotoCollectionViewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 31.07.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import RealmSwift

//private let reuseIdentifier = "friendsPhotoCell"

class FriendsPhotoCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    private let realmService = RealmService.shared
    lazy var photoCacheService = PhotoCacheService(container: self.collectionView)
    
    var ownerId: Int = 0
    var userPhotosArray: [UserPhotos]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPhoto()
    }
    
    // MARK: Methods by Dev
    
    private func loadPhoto(completion: (() -> Void)? = nil) {
        
//        guard userPhotosArray != nil else { return }
       
        NetworkService.shared.personsPhotoRequest(ownerId: ownerId) { [weak self] photos in
            print("OwnerId: \(String(describing: self?.ownerId))")
            DispatchQueue.main.async {
                self?.userPhotosArray = photos
                completion?()
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userPhotosArray?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsPhotoCell", for: indexPath) as! FriendsPhotoCollectionViewCell
        guard let userPhotoSizes = userPhotosArray?[indexPath.item].sizes else { return cell }
        var urlForPhoto = ""
        
        for size in userPhotoSizes {
            if size.type == "m" {
                urlForPhoto = size.url
            }
        }
        guard let url = URL(string: urlForPhoto), let data = try? Data(contentsOf: url) else { return cell }
        cell.friendsPhoto.image = UIImage(data: data)
        return cell
    }
}
