import Foundation
import Network

struct NetworkManager {
    func monitorNetwork() {
        
        let monitor = NWPathMonitor()

        monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                // do something
            } else {
                DispatchQueue.main.async {
                    print("Please turn on Wi-Fi!")
                }
            }
        }
        
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
}

