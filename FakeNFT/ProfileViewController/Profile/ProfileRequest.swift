
import Foundation

struct ProfileRequest: NetworkRequest {
    
    var endpoint: URL? {
        
        guard var components = URLComponents(string: RequestConstants.baseURL) else { return nil }
        
        let pathToAppend = "/api/v1/profile/1"
        if let currentPath = components.path.isEmpty ? nil : components.path {
            components.path = currentPath + pathToAppend
        } else {
            components.path = pathToAppend
        }
        return components.url
    }
    
    var dto: Dto? { nil }
}

struct ProfilePutRequest: NetworkRequest {
    var endpoint: URL? {
        
        guard var components = URLComponents(string: RequestConstants.baseURL) else { return nil }
        let pathToAppend = "/api/v1/profile/1"
        if let currentPath = components.path.isEmpty ? nil : components.path {
            components.path = currentPath + pathToAppend
        } else {
            components.path = pathToAppend
        }
        return components.url
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
    
    init(dto: ProfileDtoObject) {
        self.dto = dto
    }
}
