//
//  GifListPresenter.swift
//  network
//
//  Created by Виктория Козырева on 26.04.2021.
//

import Foundation

protocol GifListPresenterProtocol {
    func interact()
    func fetchData()
    func contentCount() -> Int
    func item(for index: Int) -> ImageCollectionViewModel
    func searchRequest(query: String)
}

class GifListPresenter: NSObject {
    
    var networkManager = NetworkManager()
    var images = [ImageCollectionViewModel]()
    var offset = 0
    var limit = 50
    var query = "rabbit"
    
    weak var view: GifListViewProtocol?
    
}

extension GifListPresenter: GifListPresenterProtocol {
    
    func interact() {
        view?.decorate()
        fetchData()
    }
    
    func fetchData() {
        networkManager.getGifs(query: self.query, offset: self.offset, limit: self.limit, completion: { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let data = data {
                self.images = self.images + data.map { ImageCollectionViewModel.init(url: URL.init(string: $0.images.downsized.url)!) }
                self.view?.update()
                self.offset += 50
                self.limit += 50
            }
        })
    }
    
    func item(for index: Int) -> ImageCollectionViewModel {
        return images[index]
    }
    
    func contentCount() -> Int {
        return images.count
    }
    
    func searchRequest(query: String) {
        self.query = query
        images.removeAll()
        self.offset = 0
        self.limit = 50
        fetchData()
    }
}
