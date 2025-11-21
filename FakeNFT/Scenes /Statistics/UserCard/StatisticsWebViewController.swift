import UIKit
import WebKit

final class StatisticsWebViewController: UIViewController {
    
    private let webView = WKWebView()
    private let url: URL
    
    init(url: URL, title: String? = nil) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWebView()
        loadWebsite()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backImage = UIImage(named: "back_icon")?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
    }

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadWebsite() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Actions

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
