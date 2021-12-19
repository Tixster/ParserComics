//
//  MainListTableView.swift.swift
//  Parser
//
//  Created by Кирилл Тила on 30.10.2021.
//

import UIKit

class MainListTableView: UITableView {
    
    private var titles: [TitleModel]
    var currentIndexPathRow: Int
    private lazy var footerView = LoadingCell()
    private var isLoading = false
    var fetchNextTitles: (() -> Void)?
    var fetchMangaList: (() -> Void)?
    private var tableViewRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    
    init(titles: [TitleModel], currentIndexPathRow: Int, frame: CGRect, style: UITableView.Style) {
        self.titles = titles
        self.currentIndexPathRow = currentIndexPathRow
        super.init(frame: frame, style: style)
        setupTable()
        scrollToRow(at: IndexPath(row: currentIndexPathRow, section: 0), at: .top, animated: false)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTable() {
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = .white
        register(MangaTitleCell.self, forCellReuseIdentifier: MangaTitleCell.reuseID)
        register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.reuseID)
        tableFooterView = UIView()
        refreshControl = tableViewRefreshControl
    }
    
    @objc
    private func refresh() {
        fetchMangaList?()
    }
    
    deinit {
        print(#function)
    }
    
}

extension MainListTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return titles.count
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MangaTitleCell.reuseID, for: indexPath) as! MangaTitleCell
            let title = titles[indexPath.row]
            cell.configure(mangaModel: title)
            currentIndexPathRow = indexPath.row
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseID, for: indexPath) as! LoadingCell
            cell.start()
            return cell
        default:
            return UITableViewCell()
        }
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if !isLoading {
                DispatchQueue.main.async {
                    self.fetchNextTitles?()
                }
                isLoading.toggle()
            }
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let cell = cell as? LoadingCell {
                cell.stop()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.MainTableView.heightTableViewMangaCell
        }
        
        return 50
    }
    
}

extension MainListTableView: MainParserViewControllerDelegate {
    func sendMangaData(_ vc: UIViewController, data: [TitleModel]) {
        titles = data
        isLoading = false
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.reloadData()
        }

    }
    
}
