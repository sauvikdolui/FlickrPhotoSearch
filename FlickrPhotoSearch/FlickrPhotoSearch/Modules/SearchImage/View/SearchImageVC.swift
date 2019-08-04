//
//  SearchImageVC.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import UIKit

class SearchImageVC: UIViewController {

    var _viewModel: SearchImageViewModelType?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLable: UILabel!
    
    // Dependency Injection
    let imageStore = ImageStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _viewModel = SearchImageViewModel(view: self,
                                          title: "Flickr Image Search",
                                          api: FlickrAPI.store,
                                          imageStore: imageStore)
        _viewModel?.viewDidLoad()
        
        statusLable.text = "Start typing to get result"
        tableView.isHidden = true
        statusLable.isHidden = !tableView.isHidden
        
        // UI Testing
        #if DEBUG
        self.view.accessibilityIdentifier = "SearchImageVCView"
        #endif
        
    }
    

}

extension SearchImageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        _viewModel?.searchImageForText(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        statusLable.text = "Start typing to get result"
        tableView.isHidden = true
        statusLable.isHidden = !tableView.isHidden
    }
}
// MARK: - SearchImageVCType
extension SearchImageVC: SearchImageVCType {
    func didStartANewSearch() {
        // TODO: Show Spinner
        tableView.reloadData()

    }
    func noResultFound() {
        statusLable.text = "NO RESULT FOUND"
        tableView.isHidden = true
        statusLable.isHidden = !tableView.isHidden
    }
    func setTitle(_ title: String) {
        self.title = title
    }
    func insertPhotoCellsAtIndexPath( _paths: [IndexPath]) {
        tableView.isHidden = false
        statusLable.isHidden = !tableView.isHidden
        tableView.reloadData()
        loadImagesAtIndexPaths(tableView.indexPathsForVisibleRows)
    }
    func navigateToDetailsView(model: Photo) {
        let vc = UIStoryboard(name: "SearchDetails", bundle: nil).instantiateViewController(withIdentifier: "SearchDetailsVC") as! SearchDetailsVC
        vc.viewModel = SearchDetailsViewModel(view: vc, title: model.title, photo: model, api: FlickrAPI.store)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func receiveZeroResultCount() {
        statusLable.text = "NO RESULT FOUND"
        tableView.isHidden = true
        statusLable.isHidden = !tableView.isHidden
    }
    func didFaceErrorWhileSearch(error: String) {
        statusLable.text = "Error: \(error)"
        tableView.isHidden = true
        statusLable.isHidden = !tableView.isHidden
    }
    func imageDataLoadedFor(indexPath: IndexPath, data: Data?, error: Error?){
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchResultCell else { return }
        cell.imageDataLoaded(data: data, error: error)
    }
    func imageLoadStatusChangedTo( status: PhotoLoadStatus, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchResultCell else { return }
        cell.imageLoadUpdate(status: status)

    }

}

// MARK: - UITableViewDataSource
extension SearchImageVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return _viewModel?.numberOfSections() ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _viewModel?.numberOfRowsInSection(section) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        
        // Config
        guard let model = _viewModel?.photoAtIndexPath(indexPath) else {
            return cell
        }
        cell.configWithPhoto(model, indexPath: indexPath)
        cell.viewModel = self._viewModel
        return cell
    }
    
    
}
// MARK: - UITableViewDelegate
extension SearchImageVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _viewModel?.didTapOnImageCellAtIndexPath(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO: Load Images only for visible cells only
        guard let tableView = scrollView as? UITableView else { return }
        guard let visibleCellIndexPaths = tableView.indexPathsForVisibleRows else { return }
        self.loadImagesAtIndexPaths(visibleCellIndexPaths)
    }
}


// MARK: - Private helpers
private extension SearchImageVC {
    func loadImagesAtIndexPaths(_ indexPaths: [IndexPath]?) {
        
        guard let indexPaths = indexPaths else { return }
        
        for indexPath in indexPaths {
            let cell = tableView.cellForRow(at: indexPath ) as? SearchResultCell
            cell?.loadImage()
        }
    }
}
