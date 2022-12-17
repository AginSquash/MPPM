class Order : Transactable  {

    private (set) var elements: [OrderElement] = []
    private var elementsBackup: [OrderElement] = []
    private var balance: Int = 0

    var transactionContext: TransactionContext { return _transactionContext! }
    private var _transactionContext: TransactionContext? = nil

    init(balance: Int) {
        _transactionContext = TransactionContext.createRoot(owner: self)
        self.balance = balance
    }

    func onBegin(transaction: Transaction) {
    }

    func onValidateCommit() throws {
        guard elements.count == 0 || elements.reduce(0, { $0 + $1.price }) < balance else {
            throw PieChartError.totalCheckMoreThenBalance
        }
    }

    func onCommit(transaction: Transaction) {
        elementsBackup = elements
        balance -= elements.reduce(0, { $0 + $1.price })
    }

    func onRollback(transaction: Transaction) {
        elements = elementsBackup
    }

    func addElement(label: String, price: Int) {
        let element = OrderElement(chart: self, label: label, price: price)
        elements.append(element)
    }
    
    func addElement(element: OrderElement) {
        elements.append(element)
    }

}


class OrderElement : Transactable {

    let label: String

    var price: Int {
        get { return _price }
        set { assert(transactionIsActive); _price = newValue }
    }
    private var _price: Int
    private var _priceBackup: Int

    var transactionContext: TransactionContext { return _transactionContext! }
    private var _transactionContext: TransactionContext? = nil

    init(chart: Order, label: String, price: Int) {
        self.label = label
        self._price = price
        self._priceBackup = price
        _transactionContext = TransactionContext.createNode(owner: self, parent: chart)
    }

    func onBegin(transaction: Transaction) { }

    func onValidateCommit() throws {
        guard _price > 0 else {
            throw PieChartError.elementIsNotPositive
        }
    }

    func onCommit(transaction: Transaction) {
        _priceBackup = _price
    }

    func onRollback(transaction: Transaction) {
        _price = _priceBackup
    }

}

enum PieChartError : Error {
    case elementIsNotPositive
    case totalCheckMoreThenBalance
}
