//
//  ViewController.swift
//  network
//
//  Created by Виктория Козырева on 04.04.2021.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    var networkManager: NetworkManager
    var images = [ImageCollectionViewModel]()
    var offset = 0
    var limit = 50
    var query = ""

        init() {
            self.networkManager = NetworkManager()
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.networkManager = NetworkManager()
            super.init(coder: aDecoder)
        }
    
    func config() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        //imageCollectionView.collectionViewLayout = ImageFlowCollection()
        
        imageCollectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        searchButton.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        
    }
    
    @objc func tapButton(sender: UIButton) {
        self.query = queryTextField.text!
        images.removeAll()
        self.offset = 0
        self.limit = 50
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        fetchData()
    }
 
    func fetchData() {
        networkManager.getGifs(query: self.query, offset: self.offset, limit: self.limit, completion: { [weak self] (data, error) in
            if let error = error {
                print(error)
            }
            if let data = data {
                self?.images = self!.images + data.map { ImageCollectionViewModel.init(url: URL.init(string: $0.images.downsized.url)!) }
                DispatchQueue.main.async {
                    self?.imageCollectionView.reloadData()
                }
                self?.offset += 50
                self?.limit += 50
            }
        })
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        let imageUrl = self.images[indexPath.item]
        cell.config(url: imageUrl.url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= images.count - 1 {
            fetchData()
        }
    }
   
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 180, height: 180)
    }
}


