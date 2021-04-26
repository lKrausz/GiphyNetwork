//
//  ViewController.swift
//  network
//
//  Created by Виктория Козырева on 04.04.2021.
//

import UIKit
import SDWebImage

protocol GifListViewProtocol: class {
    func decorate()
    func update()
}

class GifListViewController: UIViewController {
    
    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var presenter: GifListPresenterProtocol?
    
    init(presenter: GifListPresenter) {
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func tapButton(sender: UIButton) {
        guard let text = queryTextField.text else { return }
        presenter?.searchRequest(query: text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.interact()
    }
    
    
}

extension GifListViewController: GifListViewProtocol {
    func decorate() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        //imageCollectionView.collectionViewLayout = ImageFlowCollection()
        
        imageCollectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        searchButton.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
    }
    
    func update() {
        DispatchQueue.main.async { [weak self] in
            self?.imageCollectionView.reloadData()
        }
    }
}

extension GifListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.contentCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        let imageUrl = self.presenter?.item(for: indexPath.row)
        cell.config(url: imageUrl?.url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = presenter?.contentCount() else { return }
        if indexPath.row >= count - 1 {
            presenter?.fetchData()
        }
    }
    
}

extension GifListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 180, height: 180)
    }
}


