//
//  FriendsPhotoCollectionViewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 31.07.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "friendsPhotoCell"

class FriendsPhotoCollectionViewController: UICollectionViewController {

//    let friendsArray = NetworkService.shared.friendsRequest {
//        completion()
//    }
    
    
    var ownerId: Int = 0
    
    var userPhotosArray: [UserPhotos] {
        loadPhoto()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: Function to get photo
    
    private func loadPhoto() -> [UserPhotos] {
        var userPhotos = [UserPhotos]()
        NetworkService.shared.personsPhotoRequest(ownerId: ownerId) { [weak self] photos in

            DispatchQueue.main.async {
                userPhotos = photos

                self?.collectionView.reloadData()
                
            }
        }
        return userPhotos
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userPhotosArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsPhotoCell", for: indexPath) as! FriendsPhotoCollectionViewCell
        
        let photoSizesDict = userPhotosArray[indexPath.row].sizes
        var urlForPhoto: String = ""
        
        for (_, value) in photoSizesDict {
            if value == "m" {
                urlForPhoto = photoSizesDict["photoType"] ?? ""
            }
        }
        
        guard let url = URL(string: urlForPhoto), let data = try? Data(contentsOf: url) else { return cell }
        
        cell.friendsPhoto.image = UIImage(data: data)
    
        return cell
    }

    

}
