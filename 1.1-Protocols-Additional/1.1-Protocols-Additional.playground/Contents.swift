import Foundation
import UIKit
// 1. Можно ли ограничить протокол только для классов?
//Можно, добавив ограничение AnyObject, так как классы подписаны под него
protocol ClassOnly: AnyObject{}
class SomeClass: ClassOnly{}
//struct SomeStruct: ClassOnly{} выдаст ошибку, так как структуры не принадлежат AnyObject
//protocol P: class {} - это то же самое, за исключением разницы в обращении к объектам из Objective-C

// 2. Можно ли создать опциональные функции (необязательные к реализации) у протоколов?
//Можно, при этом атрибут @objc дает совместимость с Objective-C кодом, что ограничивает его использование только классами
@objc protocol OptionalProtocol{
    func nonOptionalFunc()  //Обязательно
   @objc optional func optionalFunc()   //Не обязательно
}
//Если же нужно использовать опциональные методы структурах и энумах, то теоритически можно создать пустой протокол и расширить его
protocol OptionalProtocolForAll{
    func nonOptionalFunc()
}
extension OptionalProtocolForAll{
    func optionalFunc(){print("I am not required")}
}
struct SomeStruct: OptionalProtocolForAll {
    func nonOptionalFunc() { print("i am non optional func") }
}
// 3. Можно ли в extension создавать хранимые свойства (stored property)? Если да, то в каких случаях? А если нет, то есть ли способы обойти данные ограничения?
//Официально, конечно, нельзя, extension лишь расширяют функционал, поэтому можно добавить лишь новые вычисляемые свойства. Можно лишь расширить инициализатор:
//1 способ
extension SomeClass {
    private static var _myComputedProperty = [String:Int]()
    
    var myComputedProperty:Int {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return SomeClass._myComputedProperty[tmpAddress] ?? 0
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            SomeClass._myComputedProperty[tmpAddress] = newValue
        }
    }
}

//2-й способ
public final class ObjectAssociation<T: AnyObject> {

    private let policy: objc_AssociationPolicy

    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {

        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {

        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

extension SomeClass {

    private static let association = ObjectAssociation<NSObject>()

    var simulatedProperty: NSObject? {

        get { return SomeClass.association[self] }
        set { SomeClass.association[self] = newValue }
    }
}
var someClass = SomeClass()
someClass.myComputedProperty
someClass.simulatedProperty

// 4. Можно ли в extension объявлять вложенные типы, а именно: классы/структуры/перечисления/протоколы.
//Можно, не вложенные типы нет огрчничений
extension Int{
    enum EnumSign{}
    class ClassSign{}
    struct StructSign{}
}
// 5. Можно ли в extension класса/структуры/перечисления реализовать соответствие протоколу?
//Можно, но соответственно надо реализовать обязательные методы/свойства
extension SomeClass: OptionalProtocolForAll{
    func nonOptionalFunc() { print("i am non optional func") }
}
// 6. Можно ли в протоколе объявить инициализатор? А в extension добавить новый инициализатор для класса/структуры/перечисления/протокола?
//Можно и объявить, и расширить. Пример с расширением описал в задании 3.
protocol Initiablee{
    init()
}
// 7. Как в протоколе объявить readonly свойство? Можно ли его реализовать в классе/структуре/перечислении с помощью let?
protocol TestProtocol{
    var testValue: Int{ get }   //Значение будет ридонли, объявляется оно как var, но имеет только геттер.
}
class TestClass: TestProtocol{
    let testValue: Int = 0
}//пример
//Соответственно, если оно будет объявлено как let, то все будет правильно
// 8. Поддерживают ли протоколы множественное наследование?
//Поддерживают всегда, важно только понимать, как мне видится, чтобы их назначение не конфликтовало друг с другом
protocol FirstP{}
protocol SecondP: FirstP {}
protocol ThirdP: SecondP {}
//9. Можно ли создать протокол, реализовать который могут только определенные классы/структуры/перечисления?
//Можно наложить ограничение, после которого наследовать сможет группа классов, это в определенной степени сужает круг классов, которые могут принимать протокол
protocol ForEquatable: Equatable{}
protocol OnlyForViewController: UIViewController {}
class TTT: UIViewController, OnlyForViewController{}//так будет работать
// 10. Можно ли определить тип, который реализует одновременно несколько несвязанных между собой протоколов?
//Немного не понял вопрос: несвязанных или конфликтующих? Потому что в целом могут принимать любые протоколы, которые не связаны друг с другом, это ведь не наследование
class Vinegret: ThirdP, OptionalProtocolForAll, ClassOnly{
    func nonOptionalFunc() {}
}//Протоколы друг с другом не связаны
protocol A {}
protocol B {}
protocol C {}
typealias AB = A & B
