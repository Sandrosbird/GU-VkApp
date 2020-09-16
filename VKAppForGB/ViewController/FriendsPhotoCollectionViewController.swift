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

//    let friendsArray = NetworkService.shared.friendsRequest {
//        completion()
//    }
    // MARK: Properties
    private let realmService = RealmService.shared
    private var realmToken: NotificationToken?
    
    var ownerId: Int = 0
    var userPhotosArray: Results<UserPhotos>? = {
        let photo: Results<UserPhotos>? = RealmService.shared?.getFromRealm()
        return photo
        
    }()
    
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRealmNotification()
        
        if let userPhotosArray = userPhotosArray, userPhotosArray.isEmpty {
            loadPhoto()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ownerId = 0
    }

    // MARK: Methods by Dev
    
    private func loadPhoto(completion: (() -> Void)? = nil) {
        
        guard userPhotosArray != nil else { return }
        
        NetworkService.shared.personsPhotoRequest(ownerId: ownerId) { [weak self] photos in
            print("OwnerId: \(String(describing: self?.ownerId))")
            DispatchQueue.main.async {
                try? self?.realmService?.addManyObjects(objects: photos)
                
                self?.collectionView.reloadData()
                
                completion?()
                
            }
        }
    }
    
    private func createRealmNotification() {

        realmToken = userPhotosArray?.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                
//                do {
//                    try? self.realmService?.deleteSingleObject(object: PhotoSizes.self)
//                    try? self.realmService?.addManyObjects(objects: [UserPhotos.self])
//                } catch {
//                    print(error.localizedDescription)
//                }
                self.collectionView.reloadData()
                print("initial")

            case .update(_, _: _, _: _, _: _):
                
                

                self.collectionView.reloadData()
                print("update")


            case .error(let error):

                print(error.localizedDescription)
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
