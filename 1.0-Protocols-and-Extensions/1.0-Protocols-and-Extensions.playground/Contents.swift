import Foundation
import UIKit

/*4. Напишите, в чём отличие класса от протокола.
 //Класс описывает свойства и методы, протокол же их только обозначает. Соответсвенно класс - самостоятельный тип, который можно присвоить объекту, протокол же - нет.
 UPD:
 protocol A {}
 class AImpl: A {}

 let a: A = AImpl()
 
 Да, константа а является типом протокола, однако мы можем создать class BImpl: A {} и его экзепляу тоже можно дать тип А.
 Если выражаться точнее, то класс - это "Конечная" реализация, а протокол лишь "макет". Он только задает логику, но не описывает ее.(Да, логику можно описать в extension, но она будет всего лишь дефолтной, её можно переопределить)
 Соответсвенно, все вышесказанное дает нам возможность создать некий протокол A с определенным набором поведения, который
 будут принимать в себя классы AImpl и BImpl. Они будут вынуждены описывать одинаковые методы из протокола А, но вот делать они это могут совершенно по-разному. Соответственно объекты подписанные под классами AImpl/BImpl могут быть типа A.
 
 5. Ответьте, могут ли реализовывать несколько протоколов:
 a) классы (Class),
 b) структуры (Struct)
 c) перечисления (Enum)
 d) кортежи (Tuples).
 Протоколы поддерживают множественное наследование, но только для классов, структур и перечислений. кортежи вообще не могут принять протокол7
 
 6. Создайте протоколы для:
 a) Игры в шахматы против компьютера: 1) протокол-делегат с функцией, через которую шахматный движок будет сообщать о ходе компьютера (с какой на какую клетку); 2) протокол для шахматного движка, в который передаётся ход фигуры игрока (с какой на какую клетку); Double-свойство, возвращающее текущую оценку позиции (без возможности изменения этого свойства) и свойство делегата.
 */
enum CellAlphabetic: String{
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    case f = "F"
    case g = "G"
    case h = "H"
}
enum CellNumberic: Int{
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
}
typealias ChessCoordinates = (alpha: CellAlphabetic, number: CellNumberic)

protocol ChessBoardDelegate{
    var computerDelegate: ChessEngine? { get set }
    func computerDidMove(at: ChessCoordinates)//возвращаем ход
}
extension ChessBoardDelegate{
    func computerDidMove(at: ChessCoordinates){
        print(at.alpha.rawValue, at.number.rawValue)
    }
}

protocol ChessEngine{
    var delegate: ChessBoardDelegate? { get set }  //делегат
    var estimation: ChessCoordinates { get }            //оценка
    func calculateMove(coordinates: ChessCoordinates)        //вычисление хода на основании хода игрока
}
extension ChessEngine{
    func calculateMove(coordinates: ChessCoordinates) {
        delegate?.computerDidMove(at: estimation)
    }
}
class ComputerChess: ChessEngine{
    var delegate: ChessBoardDelegate?
    var estimation = ChessCoordinates(CellAlphabetic.a, CellNumberic.one)
}
class PlayerChess: ChessBoardDelegate{
    var computerDelegate: ChessEngine?
    func playerDidMove(at: ChessCoordinates){
        computerDelegate?.calculateMove(coordinates: at)
    }
}
var player = PlayerChess()
var computer = ComputerChess()
computer.delegate = player
player.computerDelegate = computer
player.playerDidMove(at: ChessCoordinates(CellAlphabetic.b, CellNumberic.six))
// b) Компьютерной игры: один протокол для всех, кто может летать (Flyable), второй — для тех, кого можно отрисовывать в приложении (Drawable). Напишите класс, который реализует эти два протокола.

protocol Flyable{
    func canFly()
}
protocol Drawable{
    func canBeDrawed()
}
class Dragon: Flyable, Drawable{
    func canFly() {
        print("i can fly")
    }
    
    func canBeDrawed() {
        print("can be drawed")
    }
}
let ultimateBoss = Dragon()
ultimateBoss.canFly()
ultimateBoss.canBeDrawed()

//7. Создайте расширение с функцией для:
//  a) CGRect, которая возвращает CGPoint с центром этого CGRect’а.
extension CGRect{
    func returnCenter()->CGPoint{
        return CGPoint(x: midX, y: midY)
    }
    var square: Double { return Double(width * height) }
    func returnSquare()->Double{
        return Double(width * height)
    }
}
let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
rect.square
rect.returnCenter()
// b) CGRect, которая возвращает площадь этого CGRect’а.
rect.returnSquare()
// c) UIView, которое анимированно её скрывает (делает alpha = 0).
extension UIView{
    func hide(){
        UIView.animate(withDuration: 2.0){
            self.alpha = 0
        }
    }
}
let view = UIView()
view.alpha = 1
view.hide()
print(view.alpha)
// d) Протокола Comparable, который на вход получает ещё два параметра того же типа: первый  ограничивает минимальное значение, второй —  максимальное, — и возвращает текущее значение, ограниченное этими двумя параметрами.
extension Comparable{
    func bound(minX: Self, maxX: Self) -> Self? {
        guard minX < maxX else { return nil }
        switch self {
        case ...minX:
            return minX
        case maxX...:
            return maxX
        default:
            return self
        }
    }
}
var three = 3
three.bound(minX: 100, maxX: 5)

//e) Array, который содержит элементы типа Int: функцию для подсчёта суммы всех элементов.
extension Array where Element == Int{
    func summary()->Int{
        return self.reduce(0, +)
    }
}
let arr = [3, 6, 7, 13, 5]

arr.summary()

//8. Напишите, в чём основная идея Protocol Oriented Programming.
/*Логика работы POP строится от описания функциональности, а не её реализации. Таким образом можно преиспользовать единожды
 созданную логику уже непосредственно в классах. */
