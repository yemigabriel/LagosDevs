//
//  ViewController.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/8/22.
//

import UIKit
import Combine

class HomeVC: UIViewController {

    private let profileList = ProfileList()
    private var viewModel: ProfileListVM?
    private var cancellables = Set<AnyCancellable>()
    private var indexPaths: [IndexPath] = []
    
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
        setUpBindings()
    }
    
    func setUp() {
        navigationItem.title = "Lagos Devs"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favourites", style: .plain, target: self, action: #selector(didTapFavouritesBtn))
        
        profileList.tableView.delegate = self
        profileList.tableView.dataSource = self
        profileList.tableView.prefetchDataSource = self
        profileList.tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
    }
    
    func setUpBindings() {
        viewModel?.getPersistedProfiles()
        viewModel?.$appState
            .receive(on: DispatchQueue.main, options: nil)
            .sink{ [weak self] appstate in
                if appstate == .loading {
                    self?.profileList.activityIndicator.startAnimating()
                } else {
                    self?.profileList.activityIndicator.stopAnimating()
                }
            }
        .store(in: &cancellables)
        
        viewModel?.$groupedProfileResults
            .receive(on: DispatchQueue.main, options: nil)
            .sink {[weak self] profiles in
                guard let self = self else { return }
                if profiles.isEmpty {
                    self.viewModel?.isFetchingProfiles = true
                    self.viewModel?.fetchRemoteProfiles()
                    self.viewModel?.getPersistedProfiles()
                }
                
                if self.indexPaths.isEmpty {
                    self.profileList.tableView.reloadData()
                } else {
                    self.profileList.tableView.reloadRows(at: self.indexPaths, with: .none)
                    self.profileList.tableView.beginUpdates()
                    self.profileList.tableView.endUpdates()
                }
                self.viewModel?.appState = .ready
                self.viewModel?.isFetchingProfiles = false
                
        }
        .store(in: &cancellables)
    }
    
    @objc func didTapFavouritesBtn() {
        let favouritesVC = FavouritesVC()
        navigationController?.pushViewController(favouritesVC, animated: true)
    }
}

extension HomeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.groupedProfileResults.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.groupedProfileResults[section].profiles.count ?? 0
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.groupedProfileResults.map{$0.letter}
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.groupedProfileResults[section].letter
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as? ProfileCell else { fatalError() }

        if let section = viewModel?.groupedProfileResults[indexPath.section] {
            let profile = section.profiles[indexPath.row]
            cell.configure(with: .init(profile: profile))
        }
        return cell
    }
    
}

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (tableView.cellForRow(at: indexPath) as? ProfileCell) != nil else { return }

        if let section = viewModel?.groupedProfileResults[indexPath.section] {
            let profile = section.profiles[indexPath.row]
            let profileDetailVC = ProfileDetailVC()
            profileDetailVC.profileVM = .init(profile: profile)
            present(profileDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

extension HomeVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let viewModel = viewModel else { return }
        
        for indexPath in indexPaths {
            if !(tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false) && !viewModel.isFetchingProfiles && viewModel.pages > viewModel.currentPage {
                viewModel.currentPage += 1
                viewModel.isFetchingProfiles = true
                self.indexPaths.appendDistinct(contentsOf: indexPaths, where: { $0 == $1 })
                viewModel.fetchRemoteProfiles()
                viewModel.getPersistedProfiles()
            }
        }
        
    }
}
