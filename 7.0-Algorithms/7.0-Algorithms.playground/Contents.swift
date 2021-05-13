import Foundation

//MARK:-- Linked List
//Сам Node
class LLNode<T: StringProtocol> {
    var value: T?
    
    var next: LLNode<T>?
    weak var previous: LLNode<T>?
    
    init(value: T?) {
        self.value = value
    }
    //Инициализатор через сассив. Вещь сейчас не совсем нужная, но решил оставить
    convenience init(values: [T]) {
        self.init(value: values.first)
        var current = self
        for i in 1..<values.count {
            let next = LLNode(value: values[i])
            current.next = next
            current = next as! Self
        }
    }
}
//Сам Linked List
public class LinkedList<T: StringProtocol> {
    private var head: LLNode<T>?
    private var tail: LLNode<T>?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    var first: LLNode<T>? {
        return head
    }
    
    var last: LLNode<T>? {
        return tail
    }
    
    init() {
        self.head = nil
        self.tail = nil
    }
    //Добавление
    public func append(value: T) {
        let newNode = LLNode(value: value)
        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
        }
        else {
            head = newNode
        }
        tail = newNode
    }
    //Поиск по индексу
    func nodeAt(index: Int) -> LLNode<T>? {
        if index >= 0 {
            var node = head
            var i = index
            while node != nil {
                if i == 0 { return node }
                i -= 1
                node = node!.next
            }
        }
        return nil
    }
    //Поиск по строке
    func findNodeByString(string: T) -> LLNode<T>? {
        var node = head
        while node?.next != nil {
            if node?.value == string { return node }
            node = node?.next
        }
        return nil
    }
}
//MARK:-- Проверка
var  list = LinkedList<String>()
list.append(value: "A")
list.append(value: "B")
list.append(value: "C")
list.append(value: "D")
list.append(value: "E")
list.nodeAt(index: 3)?.value
list.findNodeByString(string: "O")?.value

//MARK:-- Бинарное дерево поиска
//Node
class TreeNode<T: StringProtocol> {
    var value: T?
    
    var left: TreeNode<T>?
    var right: TreeNode<T>?
    
    init(value: T?) {
        self.value = value
    }
}
//Само дерево
enum SearchTree<T: StringProtocol>{
    case empty
    indirect case node(SearchTree, T, SearchTree)
    //Вставка
    mutating func insert(newValue: T) {
        self = newTreeWithInsertedValue(newValue: newValue)
    }
    //Здесь мы не вставляем значение нового дерева в старое, а создаем обновленное дерево заново
    private func newTreeWithInsertedValue(newValue: T) -> SearchTree {
        switch self {
        
        case .empty:
            return .node(.empty, newValue, .empty)
            
        case let .node(left, value, right):
            if newValue < value {
                return .node(left.newTreeWithInsertedValue(newValue: newValue), value, right)
            } else {
                return .node(left, value, right.newTreeWithInsertedValue(newValue: newValue))
            }
        }
    }
    //Поиск
    func search(searchValue: T) -> SearchTree? {
        switch self {
        case .empty:
            return nil
        case let .node(left, value, right):
            
            if searchValue == value {
                return self
            }
            
            if searchValue < value {
                return left.search(searchValue: searchValue)
            } else {
                return right.search(searchValue: searchValue)
            }
        }
    }
}

extension SearchTree: CustomStringConvertible {
    //Описание для удобства
    var description: String {
        switch self {
        case let .node(left, value, right):
            return "value: \(value), left = [" + left.description + "], right = [" + right.description + "]"
        case .empty:
            return ""
        }
    }
    //Добавил для себя - попрактиковаться
    var count: Int {
        switch self {
        case let .node(left, _, right):
            return left.count + 1 + right.count
        case .empty:
            return 0
        }
    }
}
//MARK:-- Проверка
var tree: SearchTree<String> = .empty
tree.insert(newValue: "E")
tree.insert(newValue: "B")
tree.insert(newValue: "A")
tree.insert(newValue: "F")
tree.insert(newValue: "D")
tree.insert(newValue: "P")
print(tree)
tree.search(searchValue: "F")

//MARK:-- Граф

class Vertex {
    var name: String
    var visited = false
    var connections: [Edge] = []
    init(name: String) {
        self.name = name
    }
}

extension Vertex: CustomStringConvertible {
    var description: String {
        return "\(name)"
    }
}

class Edge {
    public let to: Vertex
    public let time: TimeInterval
    
    public init(to node: Vertex, time: TimeInterval) {
        self.to = node
        self.time = time
    }
}

extension Edge: CustomStringConvertible {
    var description: String {
        return "To: \(to.name), time: \(time)."
    }
}

class Path {
    public let cumulativeWeight: Int
    public let node: Vertex
    public let previousPath: Path?
    
    init(to node: Vertex, via connection: Edge? = nil, previousPath path: Path? = nil) {
        if
            let previousPath = path,
            let viaConnection = connection {
            self.cumulativeWeight = Int(viaConnection.time) + previousPath.cumulativeWeight
        } else {
            self.cumulativeWeight = 0
        }
        
        self.node = node
        self.previousPath = path
    }
}

extension Path {
    var array: [Vertex] {
        var array: [Vertex] = [self.node]
        
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.node)
            
            iterativePath = path
        }
        
        return array
    }
}

extension Path: CustomStringConvertible {
    var description: String {
        return "\(array); time: \(cumulativeWeight)."
    }
}


func shortestPath(source: Vertex, destination: Vertex) -> Path? {
    var frontier: [Path] = [] {
        didSet { frontier.sort { return $0.cumulativeWeight < $1.cumulativeWeight } }
    }
    
    frontier.append(Path(to: source))
    
    while !frontier.isEmpty {
        let cheapestPathInFrontier = frontier.removeFirst()
        guard !cheapestPathInFrontier.node.visited else { continue }
        
        if cheapestPathInFrontier.node === destination {
            return cheapestPathInFrontier
        }
        
        cheapestPathInFrontier.node.visited = true
        
        for connection in cheapestPathInFrontier.node.connections where !connection.to.visited {
            frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
        }
    }
    return nil
}
//MARK:-- Проверка

let node1 = Vertex(name: "I")
let node2 = Vertex(name: "II")
let node3 = Vertex(name: "III")
let node4 = Vertex(name: "IV")
let node5 = Vertex(name: "V")
let node6 = Vertex(name: "VI")
let node7 = Vertex(name: "VII")

node1.connections.append(Edge(to: node2, time: 300))
node2.connections.append(Edge(to: node3, time: 600))
node3.connections.append(Edge(to: node4, time: 400))
node4.connections.append(Edge(to: node6, time: 300))
node1.connections.append(Edge(to: node5, time: 500))
node5.connections.append(Edge(to: node6, time: 550))
node6.connections.append(Edge(to: node7, time: 200))
node7.connections.append(Edge(to: node2, time: 500))
node2.connections.append(Edge(to: node7, time: 100))

print(shortestPath(source: node1, destination: node7))

//MARK:-- Сортировка массивов

//вставка
extension Array where Element: Comparable {
    
    func insertionSort() -> Array<Element> {
        
        guard self.count > 1 else {
            return self
        }
        
        var output: Array<Element> = self
        
        for primaryindex in 0..<output.count {
            
            let key = output[primaryindex]
            var secondaryindex = primaryindex
            
            while secondaryindex > -1 {
                if key < output[secondaryindex] {
                    
                    output.remove(at: secondaryindex + 1)
                    output.insert(key, at: secondaryindex)
                }
                secondaryindex -= 1
            }
        }
        
        return output
    }
    //быстрая сортировка
    mutating func quickSort() -> Array<Element> {
        
        func qSort(start startIndex: Int, _ pivot: Int) {
            
            if (startIndex < pivot) {
                let iPivot = qPartition(start: startIndex, pivot)
                qSort(start: startIndex, iPivot - 1)
                qSort(start: iPivot + 1, pivot)
            }
        }
        qSort(start: 0, self.endIndex - 1)
        return self
    }
    
    mutating private func qPartition(start startIndex: Int, _ pivot: Int) -> Int {
        
        var wallIndex: Int = startIndex
        
        for currentIndex in wallIndex..<pivot {
            
            if self[currentIndex] <= self[pivot] {
                if wallIndex != currentIndex {
                    self.swapAt(currentIndex, wallIndex)
                }
                
                wallIndex += 1
            }
        }
        if wallIndex != pivot {
            self.swapAt(wallIndex, pivot)
        }
        return wallIndex
    }
}

//MARK:-- Проверка
var arr1 = [5, 4, 2, 80, 35]
arr1.quickSort()
var arr2 = ["E", "Z", "D", "T", "A"]
arr2.insertionSort()
