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
        register(BaseTableViewCell.self, forCellReuseIdentifier: recentSearchCellId)
        setUpTheming()
        fetchRecentSearches()
    }
    
    private let recentSearchCellId = "recentSearchCellId"
    private let sectionHeaders = ["Recent"]
    var rowSelected: ((String)->())?
    
    private var persistentContainer = CoreDataHelper.shared.getPersistentContainer()
    private lazy var context = CoreDataHelper.shared.getContext()
    private lazy var fetchedResultsController: NSFetchedResultsController<RecentSearch> = {
        let fetchRequest: NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
        let dateSort = NSSortDescriptor(key: "searchDate", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private var hasSearches: Bool {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return false }
        return fetchedObjects.count > 0
    }
    
    private func fetchRecentSearches() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error: \(error)")
        }
    }
    
    @objc func clearPressed() {
        CoreDataHelper.shared.clearRecentSearches()
        self.fetchRecentSearches()
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fetchedObject = fetchedResultsController.object(at: indexPath)
        rowSelected?(fetchedObject.searchText!)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // TODO: Make header without clear button
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return UIView() }
        let count = fetchedObjects.count
        let recentSearchesHeader = RecentSearchesSectionHeader()
        recentSearchesHeader.clearButton.isHidden = count == 0
        recentSearchesHeader.clearPressed = {
            self.clearPressed()
        }
        recentSearchesHeader.label.text = sectionHeaders[section]
        if section == 0 {
            
        }
        return recentSearchesHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Table View Data Source
extension RecentSearchesTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
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
        let recentSearch = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = recentSearch.searchText
        let selectedView = UIView()
        selectedView.backgroundColor = Constants.Colors().primaryColor
        cell.selectedBackgroundView = selectedView
    }
    
}

// MARK: - Fetched Results Controller Delegate
extension RecentSearchesTableView: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = cellForRow(at: indexPath) as? BaseTableViewCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
    
}

// MARK: - Themed
extension RecentSearchesTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.tableBackgroundColor
        separatorColor = theme.tableSeparatorColor
    }
}
