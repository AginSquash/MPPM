class Order : Transactable  {

    private (set) var elements: [OrderElement] = []
    private var elementsBackup: [OrderElement] = []

    // Transaction context is a mediator class that "links" transaction
    // tree together.  There are two kinds of it, a root and a node.
    var transactionContext: TransactionContext { return _transactionContext! }
    private var _transactionContext: TransactionContext? = nil

    init() {
        _transactionContext = TransactionContext.createRoot(owner: self)
    }

    func onBegin(transaction: Transaction) {
        // Back up of internal state is not needed because onCommit(), onRollback() and initialization
        // make it sure that backup is always up to date anyway.
    }

    func onValidateCommit() throws {
        guard elements.count == 0 || elements.reduce(0, { $0 + $1.percentage }) == 100 else {
            throw PieChartError.totalPercentageIsNot100
        }
    }

    func onCommit(transaction: Transaction) {
        elementsBackup = elements // Overwrite the backup to release (potentially) deleted objects
    }

    func onRollback(transaction: Transaction) {
        elements = elementsBackup // Restore the state from backup
    }

    func addElement(label: String, percentage: Int) {
        let element = OrderElement(chart: self, label: label, percentage: percentage)
        elements.append(element)
    }
    
    func addElement(element: OrderElement) {
        elements.append(element)
    }

}


class OrderElement : Transactable {

    let label: String

    var percentage: Int {
        get { return _percentage }
        set { assert(transactionIsActive); _percentage = newValue }
    }
    private var _percentage: Int
    private var _percentageBackup: Int

    var transactionContext: TransactionContext { return _transactionContext! }
    private var _transactionContext: TransactionContext? = nil

    init(chart: Order, label: String, percentage: Int) {
        self.label = label
        self._percentage = percentage
        self._percentageBackup = percentage
        _transactionContext = TransactionContext.createNode(owner: self, parent: chart)
    }

    func onBegin(transaction: Transaction) { }

    func onValidateCommit() throws {
        guard _percentage > 0 else {
            throw PieChartError.elementIsNotPositive
        }
        guard _percentage <= 100 else {
            throw PieChartError.elementIsGreaterThan100
        }
    }

    func onCommit(transaction: Transaction) {
        _percentageBackup = _percentage
    }

    func onRollback(transaction: Transaction) {
        _percentage = _percentageBackup
    }

}

enum PieChartError : Error {
    case elementIsNotPositive
    case elementIsGreaterThan100
    case totalPercentageIsNot100
}
