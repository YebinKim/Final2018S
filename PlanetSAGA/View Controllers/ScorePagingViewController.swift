//
//  ScoreViewController.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/06/17.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class ScorePagingViewController: TabmanViewController {
    
    private var viewControllers: [UIViewController] = []
    private let titles: [String] = ["My Score", "Ranking"]
    
    var defaultPage: PageboyViewController.Page = .first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myScoreTableViewController = storyboard.instantiateViewController(withIdentifier: MyScoreTableViewController.identifier)
        let rankingCollectionViewController = storyboard.instantiateViewController(withIdentifier: RankingCollectionViewController.identifier)
        
        viewControllers = [myScoreTableViewController, rankingCollectionViewController]
        
        self.dataSource = self
        
        initializeTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "color_back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor(named: "color_main")
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func initializeTabBar() {
        let bar = TMBar.ButtonBar()
        
        bar.backgroundView.style = .clear
        
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        bar.layout.transitionStyle = .snap
        
        bar.buttons.customize { button in
            button.selectedTintColor = UIColor(named: "color_main")
            button.tintColor = UIColor(named: "color_main")
        }
        bar.indicator.tintColor = UIColor(named: "color_main")
        
        addBar(bar, dataSource: self, at: .navigationItem(item: self.navigationItem))
    }
    
}

extension ScorePagingViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return defaultPage
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = titles[index]
        return TMBarItem(title: title)
    }
}
