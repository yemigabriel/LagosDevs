//
//  FavouritesVC.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/12/22.
//

import UIKit
import Combine

class FavouritesVC: UIViewController {

    private let profileList = ProfileList()
    private var viewModel: FavouriteListVM!
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = profileList
        viewModel = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpBinding()
    }
    
    private func setUp() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Favourites"
        let clearAllBtn = UIBarButtonItem(title: "Clear all", style: .plain, target: self, action: #selector(clearAllFavourites(_:)) )
        navigationItem.rightBarButtonItems = [clearAllBtn]
        
        profileList.tableView.delegate = self
        profileList.tableView.dataSource = self
        profileList.tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
    }
    
    private func setUpBinding() {
        viewModel.getFavouriteProfiles()
        viewModel.$favouriteProfiles
            .receive(on: DispatchQueue.main, options: nil)
            .sink {[weak self] profiles in
                self?.profileList.tableView.reloadData()
        }
        .store(in: &cancellables)
    }
    
    @objc func clearAllFavourites(_ sender: UIBarButtonItem) {
        viewModel.clearAllFavourites()
        profileList.tableView.reloadData()
    }
    
}

extension FavouritesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favouriteProfiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as? ProfileCell else { fatalError() }
        let favourite = viewModel.favouriteProfiles[indexPath.row]
        cell.configure(with: .init(profile: favourite))
        return cell
    }
    
}

extension FavouritesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.favouriteProfiles.isEmpty ? "No favorites added yet ..." : "Swipe left to remove profile from favourites ..."
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFavourite(at: indexPath.row)
            viewModel.favouriteProfiles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (tableView.cellForRow(at: indexPath) as? ProfileCell) != nil else { return }
        let favourites = viewModel.favouriteProfiles
        let favourite = favourites[indexPath.row]
        let profileDetailVC = ProfileDetailVC()
        profileDetailVC.profileVM = .init(profile: favourite)
        present(profileDetailVC, animated: true)
    }
    
}
