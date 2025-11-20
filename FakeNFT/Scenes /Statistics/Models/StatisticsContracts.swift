protocol StatisticsViewInput: AnyObject {
    func showLoading()
    func hideLoading()
    func showUsers(_ users: [User])
    func showError(message: String)
}

protocol StatisticsViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSortByName()
    func didTapSortByRating()
}
