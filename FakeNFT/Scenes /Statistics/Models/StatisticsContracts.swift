protocol StatisticsViewInput: AnyObject {
    func showLoading()
    func hideLoading()
    func showUsers(_ users: [User])
}

protocol StatisticsViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSortByName()
    func didTapSortByRating()
}
