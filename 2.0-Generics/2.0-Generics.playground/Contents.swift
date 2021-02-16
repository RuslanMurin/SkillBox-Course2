import Foundation
import UIKit
/*
 4. Напишите, для чего нужны дженерики.
 Дженерики - гибкие, применяемые для всех типов(в зависимости от ограничеий) абстракции. Они позволяют единожды создавать реализации методов для различных
 типов данных, что в итоге помогает сократить код, время и делает итоговый код более чистым и понятным.
 5. Укажите, чем ассоциированные типы отличаются от дженериков.
 Ассоциированные типы используются внутри протоколов. Фактически логика дейтсвий у них такая же - associatedtype объявляется внутри протокола(возможно,
 с ограничениями), затем конкретно указывается уже в наследнике протокола.
 */
// 6. Создайте функцию, которая:
//a) получает на вход два Equatable-объекта и, в зависимости от того, равны ли они друг другу, выводит разные сообщения в лог;
func equalsInLog<T: Equatable>(x: T, y: T) {
    x == y ? print("elements is equal") : print("elements is not equal")
}
equalsInLog(x: 5, y: 5)
//b) получает на вход два сравниваемых (Comparable) друг с другом значения, сравнивает их и выводит в лог наибольшее;
func compareInLog<T: Comparable>(x: T, y: T) {
    x > y ? print(x) : print(y)
}
compareInLog(x: 2, y: 5)
//c) получает на вход два сравниваемых (Comparable) друг с другом значения, сравнивает их и перезаписывает первый входной параметр меньшим из двух значений, а второй параметр — большим;
func swapForMe<T: Comparable>(_ x: inout T, _ y: inout T) {
    if x > y{
        swap(&x, &y)
    }
}
var less = 5
var greater = 3
swapForMe(&less, &greater)
print(less, greater)
//d) получает на вход две функции, которые имеют дженерик — входной параметр Т и ничего не возвращают; сама функция должна вернуть новую функцию, которая на вход получает параметр с типом Т и при своём вызове вызывает две функции и передаёт в них полученное значение (по факту объединяет две функции).
func closures<T>(first: @escaping (T)->Void, second: @escaping (T)->Void)->((T)->Void) {
    return {parameter in
        first(parameter)
        second(parameter)
    }
}
// 7. Создайте расширение для:
//a) Array, у которого элементы имеют тип Comparable, и добавьте генерируемое свойство, которое возвращает максимальный элемент;
extension Array where Element: Comparable{
    var maxEl: Element? {
        var max = self[0]
        for el in self{
            if max < el { max = el }
    }
    return max
    }
}
let max = [5, 3, 18, 34, 200, 1].maxEl
//b) Array, у которого элементы имеют тип Equatable, и добавьте функцию, которая удаляет из массива идентичные элементы.
extension Array where Element: Equatable{
    mutating func removeDuplicates() {
        var temp: [Element] = []
        for el in self{
            if !temp.contains(el){
                temp.append(el)
            }
        }
        self = temp
    }
}
var array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]

extension Array where Element: Hashable {
    mutating func removeDuplicates() {
        self = Array(Set(self))
    }
}//Очень лаконично
array.removeDuplicates()
//8. Создайте специальный оператор для:
//a) возведения Int-числа в степень: оператор ^^, работает 2^3, возвращает 8;
postfix operator ^^
postfix func ^^(number: Int) -> Int {
    return number * number * number
}
var two = 2^^
infix operator ^^
func ^^(left: Int, right: Int) -> Int {
    return Int(pow(Double(left), Double(right)))
}
5 ^^ 3
//b) копирования во второе Int-числа удвоенного значения первого 4 ~> a, после этого a = 8;
infix operator ~>
func ~>(lh: Int, rh: inout Int) {
    rh = lh * 2
}
var a = 0
4 ~> a
//c) присваивания в экземпляр tableView делегата: myController <* tableView, поле этого myController становится делегатом для tableView;
infix operator <*
func <*(delegate: UITableViewDelegate, tableView: UITableView) {
    tableView.delegate = delegate
}
class MyVC: UIViewController, UITableViewDelegate{
}
let vc = MyVC()
let table = UITableView()
vc <* table
//d) суммирует описание двух объектов с типом CustomStringConvertable и возвращает их описание: 7 + “ string” вернет “7 string”.
func +(left:CustomStringConvertible, right: CustomStringConvertible)->String {
    return left.description + right.description
}
let seven = 7
let stringSeven = " seven"
seven + stringSeven
//9. Напишите для библиотеки анимаций новый аниматор:
protocol Animator{
    associatedtype Target
    associatedtype Value
    
    var newValue: Value { get }
    
    init(_ value: Value)
    
    func animate(_ target: Target)
}

infix operator -*
func -*<T: Animator>(left: T, right: T.Target) {
    left.animate(right)
}

//a) изменяющий фоновый цвет для UIView;
class BackGroundAnimator: Animator{
    let newValue: UIColor
    required init(_ value: UIColor) {
        newValue = value
    }
    func animate(_ target: UIView) {
        UIView.animate(withDuration: 1.0) { [self] in
            target.backgroundColor = newValue
        }
    }
}
//b) изменяющий center UIView;
class CenterAnimator: Animator{
    let newValue: (CGFloat, CGFloat)
    required init(_ value: (CGFloat, CGFloat)) {
        newValue = value
    }
    func animate(_ target: UIView) {
        UIView.animate(withDuration: 1.0) { [self] in
            target.center = CGPoint(x: newValue.0, y: newValue.1)
        }
    }
}
//c) делающий scale-трансформацию для UIView.
class ScaleAnimator: Animator{
    let newValue: CGFloat
    required init(_ value: CGFloat) {
        newValue = value
    }
    func animate(_ target: UIView) {
        UIView.animate(withDuration: 1.0) { [self] in
            target.transform = CGAffineTransform(scaleX: newValue, y: newValue)
        }
    }
}

let myView = UIView()
BackGroundAnimator(.red) -* myView
myView.backgroundColor
BackGroundAnimator(.blue).animate(myView)
myView.backgroundColor
