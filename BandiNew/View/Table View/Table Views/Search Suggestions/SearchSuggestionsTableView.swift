//
//  SearchSuggestionsTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/11/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SearchSuggestionsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        dataSource = self
        delegate = self
        alwaysBounceVertical = true
        separatorInset = UIEdgeInsets(top: 0, left: 46, bottom: 0, right: 0)
        allowsSelection = true
        setUpTheming()
    }
    
    let searchSearchSuggestionsCellId = "searchSearchSuggestionsCellId"
    var suggestions: [String] = []
    var suggestionSelected: ((String) -> ())?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SuggestionTableViewCell()
        cell.textLabel?.text = suggestions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        suggestionSelected?(suggestions[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchSuggestionsTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.tableBackgroundColor
        separatorColor = theme.tableSeparatorColor
    }
}
