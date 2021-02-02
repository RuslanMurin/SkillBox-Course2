import Foundation
import UIKit

/*4. Напишите, в чём отличие класса от протокола.
 //Класс описывает свойства и методы, протокол же их только обозначает. Соответсвенно класс - самостоятельный тип, который можно присвоить объекту, протокол же - нет.
 
 5. Ответьте, могут ли реализовывать несколько протоколов:
 a) классы (Class),
 b) структуры (Struct)
 c) перечисления (Enum)
 d) кортежи (Tuples).
 Протоколы поддерживают множественное наследование, но только для классов, структур и перечислений
 
 6. Создайте протоколы для:
 a) Игры в шахматы против компьютера: 1) протокол-делегат с функцией, через которую шахматный движок будет сообщать о ходе компьютера (с какой на какую клетку); 2) протокол для шахматного движка, в который передаётся ход фигуры игрока (с какой на какую клетку); Double-свойство, возвращающее текущую оценку позиции (без возможности изменения этого свойства) и свойство делегата.*/
protocol ChessBoardDelegate{
    func computerDidMove() -> (x: Int, y: Int) //возвращаем ход
}
protocol ChessEngine{
    var delegate: ChessBoardDelegate { get }  //делегат
    var estimation: Double { get }            //оценка
    func calculateMove(x: Int, y: Int)        //вычисление хода на основании хода игрока
}

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
        return CGPoint(x: self.midX, y: self.midY)
    }
    func returnSquare()->Double{
        return Double(self.width * self.height)
    }
}
let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
rect.returnCenter()
// b) CGRect, которая возвращает площадь этого CGRect’а.
rect.returnSquare()
// c) UIView, которое анимированно её скрывает (делает alpha = 0).
extension UIView{
    func hide(){
        UIView.animate(withDuration: 2.0, animations: {
            self.alpha = 0
        })
    }
}
let view = UIView()
view.alpha = 1
view.hide()
print(view.alpha)
// d) Протокола Comparable, который на вход получает ещё два параметра того же типа: первый  ограничивает минимальное значение, второй —  максимальное, — и возвращает текущее значение, ограниченное этими двумя параметрами.
extension Comparable{
    func bound(minX: Self, maxX: Self) -> Self {
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
three.bound(minX: 1, maxX: 5)

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
