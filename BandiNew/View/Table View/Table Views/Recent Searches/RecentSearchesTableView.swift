//
//  RecentSearchesTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/13/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class RecentSearchesTableView: UITableView, UITableViewDelegate {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        dataSource = self
        delegate = self
        allowsSelection = true
        estimatedRowHeight = 55
        tableFooterView = UIView()
        separatorStyle = .none
        register(BaseTableViewCell.self, forCellReuseIdentifier: recentSearchCellId)
        setUpTheming()
    }
    
    private let recentSearchCellId = "recentSearchCellId"
    private let sectionHeaders = ["Recent"]
    private lazy var context = CoreDataHelper.shared.getContext()
    
    let fetchRequest: NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
    var searches: [RecentSearch] {
        do {
            return try context.fetch(fetchRequest).reversed()
        } catch {
            return [RecentSearch]()
        }
    }
    
    private var hasSearches: Bool {
        return searches.count > 0
    }
    
    var rowSelected: ((String)->())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Table View Delegate
extension RecentSearchesTableView {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let recentSearchesHeader = RecentSearchesSectionHeader()
        recentSearchesHeader.clearButton.isHidden = !hasSearches
        recentSearchesHeader.label.isHidden = !hasSearches
        recentSearchesHeader.clearPressed = {
            CoreDataHelper.shared.clearRecentSearches()
            self.reloadData()
        }
        recentSearchesHeader.label.text = sectionHeaders[section]
        return recentSearchesHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected?(searches[indexPath.row].searchText!)
    }
    
}

// MARK: - Table View Data Source
extension RecentSearchesTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: recentSearchCellId, for: indexPath) as! BaseTableViewCell
        configure(cell, at: indexPath)
        return cell
    }
    
    func configure(_ cell: BaseTableViewCell, at indexPath: IndexPath) {
        cell.textLabel?.font = cell.textLabel?.font.withSize(22)
        cell.textLabel?.textColor = Constants.Colors().primaryColor
        cell.textLabel?.highlightedTextColor = .white
        let recentSearch = searches[indexPath.row]
        cell.textLabel?.text = recentSearch.searchText
        let selectedView = UIView()
        selectedView.backgroundColor = Constants.Colors().primaryColor
        cell.selectedBackgroundView = selectedView
        let view = UIView(frame: CGRect(x: 15, y: 0, width: frame.width, height: 0.5))
        view.backgroundColor = AppThemeProvider.shared.currentTheme.tableSeparatorColor
        cell.addSubview(view)
    }
    
}

// MARK: - Themed
extension RecentSearchesTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.tableBackgroundColor
        separatorColor = theme.tableSeparatorColor
    }
}
