import UIKit

let imageCache = URLCache.shared

extension UIImageView {
    
    private static var taskKey: UInt8 = 0
    private var currentTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionDataTask
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(from url: URL, placeholder: UIImage? = nil) {
        
        currentTask?.cancel()
        self.image = placeholder
        self.backgroundColor = .systemGray5

        let request = URLRequest(url: url)
        if let cachedResponse = imageCache.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            
            self.image = image
            self.backgroundColor = .clear
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil,
                  let response = response else {
                
                DispatchQueue.main.async {
                    self?.image = placeholder
                }
                return
            }
            
            let cachedResponse = CachedURLResponse(response: response, data: data)
            imageCache.storeCachedResponse(cachedResponse, for: request)
            
            DispatchQueue.main.async {
                self.image = image
                self.backgroundColor = .clear
                self.currentTask = nil
            }
        }
        
        currentTask = task
        task.resume()
    }
    
    func cancelLoading() {
        currentTask?.cancel()
        currentTask = nil
    }
}
