//
//  ImagePageViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 5/5/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class ImagePageViewController: UIPageViewController {
    
    init(viewModels: [ImageViewModel]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        let imageViewControllers: [ImageViewController] = viewModels.map({ ImageViewController(viewModel: $0) })
        self.setViewControllers(imageViewControllers, direction: .forward, animated: false, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
