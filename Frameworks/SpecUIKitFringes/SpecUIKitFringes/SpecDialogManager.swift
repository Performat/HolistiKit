import Foundation

public class SpecDialogManager {

    private let errorHandler: SpecErrorHandler

    public init(errorHandler: SpecErrorHandler) {
        self.errorHandler = errorHandler
    }

    private var _visibleDialog: SpecDialog? {
        return dialogs.first
    }

    public var visibleDialog: DialogIdentifier? {
        return _visibleDialog?.identifier
    }

    private var dialogs = [SpecDialog]()
    
    func addDialog(_ identifier: SpecDialog) {
        dialogs.append(identifier)
    }

    public enum Response {
        case allow
        case dontAllow
        case settings
        case cancel
    }

    func tap(_ response: Response) {
        guard let dialog = popDialog() else {
            errorHandler.error(.noDialog)
            return
        }
        let isValidResponse = dialog.responded(with: response)
        if !isValidResponse {
            errorHandler.error(.notAValidDialogResponse)
        }
    }

    func popDialog() -> SpecDialog? {
        if dialogs.isEmpty { return nil }
        return dialogs.remove(at: 0)
    }
}
