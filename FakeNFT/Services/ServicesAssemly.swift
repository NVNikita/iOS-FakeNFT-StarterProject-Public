final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let myNftStorage: MyNftStorage
    private let currencyStorage: CurrencyStorageProtocol
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        myNftStorage: MyNftStorage,
        currencyStorage: CurrencyStorageProtocol = CurrencyStorage()
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.myNftStorage = myNftStorage
        self.currencyStorage = currencyStorage
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }
    
    var myNftService: MyNftService {
        MyNftServiceImpl(
            networkClient: networkClient,
            storage: myNftStorage
        )
    }

    var currencyService: CurrencyServiceProtocol {
        CurrencyService(
            networkClient: networkClient,
            storage: currencyStorage
        )
    }
}
