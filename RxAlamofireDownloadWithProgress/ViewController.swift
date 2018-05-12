//
//  ViewController.swift
//  RxAlamofireDownloadWithProgress
//
//  Created by Marius Pop on 12/05/2018.
//  Copyright © 2018 SwiftUni. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

class ViewController: UIViewController {
    private let bag = DisposeBag()

    // Props to: http://www.drawingsofdogs.co.uk/ for the image
    private let targetURL = "https://i.imgur.com/D7TW5Ec.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

