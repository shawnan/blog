---
title: JavaScript对象构造函数及继承学习笔记
date: 2015/9/11 23:11:00
tags: JavaScript
---
为了加深自己对JavaScript的Object类型的理解，对这部分的内容整理了一些笔记，几乎完全是《JavaScript高级程序设计》的摘抄，仅仅是方便自己的学习。
   
# Object类型 #
   
在JavaScript中，是没有传统的面向对象语言的那种类的，JavaScript中的对象是引用类型， 引用类型的值是引用类型的一个实例，在ECMAScript中，引用类型是一种数据结构，用于将数据和功能组织在一起。   
<!--more-->
   
### 创建Object ###

创建Object有两种方式：   
1、使用new操作符后跟Object构造函数。

    var person = new Object();
    person.name = "Shawnan";
    person.age = 24;
    
2、使用对象字面量表示法。

    var person = {
        name: "Shawnan",
        age: 29
    };

访问对象属性也有两种方式：   
1、点表示法。
   
    alert(person.name);

2、方括号表示法。

    alert(person["name"]);

方括号表示法的优点是可以通过变量来访问属性，或者属性名使用的是关键字或保留字或包含空格等。但是，除非必须的情况，否则推荐使用点表示法。

### 属性类型 ###

#### 数据属性 ####

数据属性包含一个数据值的位置，这个位置可以读取和写入值。数据属性有4个描述其行为的特性。    
[[Configurable]]：表示能否通过delete删除属性从而重新定义属性，能否修改属性的特性，或者能否把属性修改为访问器属性。直接在对象上定义的属性，这个特性默认值为true。    
[[Enumerable]]：表示能否通过for-in循环返回属性。直接在对象上定义的属性，这个特性默认值为true。   
[[Writable]]：表示能否修改属性的值。直接在对象上定义的属性，这个特性默认值为true。   
[[Value]]：包含这个属性的数据值。读取属性值的时候，从这个位置读；写入属性值的时候，把新值保存在这个位置。这个特性默认值为undefined。而直接在对象上定义的属性，这个值就为定义时的值，并且所有对这个值的修改都将反映在这个位置。    
要修改属性默认的特性，必须使用ECMAScript5defineProperty()方法。这个方法接收三个参数：属性所在的对象、属性的名字和一个描述符对象。其中，描述符（descriptor）对象的属性必须是“configurable、enumerable、writable和value。设置其中一或多个值可以修改对应的特征值。例如设置只读禁止修改，禁止删除等。    
在调用Object.defineProperty()方法时，如果不指定，configurable、enumerable和writeable特性的默认值都是false。   

#### 访问器属性 ####

访问器属性不包含数值，他们包含一对儿getter和setter函数（不过，这两个函数都不是必须的）。
读取访问器属性值，会调用getter函数，这个函数返回有效的值；在写入访问器属性时，会调用setter函数并传入新值，这个函数负责决定如何处理数据。    
访问器属性有如下4个特性。    
[[Enumerable]]：表示能否通过for-in循环返回属性。直接在对象上定义的属性，这个特性默认值为true。   
[[Writable]]：表示能否修改属性的值。直接在对象上定义的属性，这个特性默认值为true。  
[[Get]]：在读取属性时调用的函数。默认值为undefined。   
[[Set]]：在写入属性时调用的函数。默认值为undefined。   
访问器属性不能直接定义，必须使用Object.defineProperty()来定义。   

#### 定义多个属性 ####

ECMAScript5定义了一个Object.defineProperties()方法，利用这个方法可以通过描述符一次定义多个属性。这个方法接收两个对象参数：第一个对象是要添加和修改其属性的对象，第二个对象的属性与第一个对象中要添加或修改的属性一一对应。   

#### 读取属性的特性 ####

使用ECMAScript5的Object.getOwnPropertyDescriptor()方法，可以取得给定属性的描述符。这个方法接收两个参数：属性所在的对象和要读取其描述符的属性名称。返回值是一个对象，若是访问器属性则有configurable、enumerable、get和set等属性；若是数据属性，则有configurable、enumerable、writable和value等属性。    

## 创建对象 ##

### 工厂模式 ###

工厂模式是软件工程领域一种广为人知的设计模式，这种模式抽象了创建具体对象的过程。   
用工厂模式来创建对象，就是设计一个接收参数的函数，这个函数返回一个具有相应属性和方法的对象。

    function createPerson(name, age, job){
    	var o = new Object();
    	o.name = name;
    	o.age = age;
    	o.job = job;
    	o.sayName = function(){
    		alert(this.name);
    	};
    	return o;
    }
    var person1 = createPerson("Shawnan", 24, "Software Engineer");
   
工厂模式的弊端是没有解决对象识别的问题，无法判断某个对象是什么类型。   

### 构造函数模式 ###

构造函数模式就是与其他OO语言类似的，采用创建对象时的构造函数。    

    function Person(name, age, job){
    	this.name = name;
    	this.age = age;
    	this.job = job;
    	this.sayName = function(){
    		alert(this.name);
    	};
    }
    var person1 = new Person("Shawnan", 24, "Software Engineer");

构造函数模式的代码与工厂模式十分类似，但是在构造函数内部没有再创建新的对象，而是直接将属性和方法赋值给了this对象，最后也没有return语句。并且函数名采用了大写字母P开头，这是为了方便构造函数区别于其他普通函数，因为构造函数本身也是函数。   

要创建Person的新实例，必须使用new操作符，调用new操作符后会经历以下4个步骤：   
1、创建一个新对象；   
2、将构造函数的作用域赋给新对象（因此this就指向了这个新对象）；   
3、执行构造函数中的代码（为这个新对象添加属性）；    
4、返回新对象。

上面person1的constructor（构造函数）属性就指向Person。   

    alert(person1.constructor == Person); //true

对象类型检测的靠谱办法是instanceof操作符。person1对象既是Object的实例，也是Person的实例，这一点可以通过instanceof操作符得到验证。

    alert(person1 instanceof Person); //true
    alert(person1 instanceof Object); //true

创建自定义的构造函数意味着将来可以将它的实例标识为一种特定的类型；而这正是构造函数模式胜过工厂模式地方。

#### 构造函数也是函数 ####

构造函数与其他函数的唯一区别，就在于调用它们的方式不同。但是，构造函数也是一种函数，不存在定义构造函数的特殊语法。任何函数，只要通过new操作符来调用，那它就可以作为构造函数；而任何函数，如果不通过new操作符来调用，那它跟普通函数也没有什么不同。     
前面定义的Person构造函数，如果作为普通函数来调用，那么它会把属性和方法都添加到当前的this，也就是window中。如果在另一个对象的作用域中调用，例如采用call方法，则会把属性和方法赋值给该对象。    

#### 构造函数的问题 ####

构造函数的主要问题，就是每个函数都要在每个实例上重新创建一遍；因为在构造函数中创建的方法，各个实例的方法并不是同一个Function的实例。ECMAScript中的函数是对象，因此每定义一个函数，也就实例化了一个对象。所以每个Person实例都包含一个不同的Function实例，所以不同实例上的同名函数是不相等的。所以，构造函数还是不能解决封装实例方法的问题。   

### 原型模式 ###

我们创建的每个函数都有一个prototype（原型）属性，这个属性是一个指针，指向一个对象，而这个对象的用途是包含可以由特定类型的所有实例共享的属性和方法。使用原型对象的好处是可以让所有对象实例共享它所包含的属性和方法。    
简单来说，就是不在构造函数中定义对象实例的信息，而是可以将所有对象实例共享它所包含的属性和方法。   
下面是一种原型模式的简单语法描述，关于原型对象，还需要再做深入的理解。

    function Person(){
    }
    Person.prototype = {
    	constructor: Person,
    	name: "Shawnan",
    	age: 24,
    	job: "Software Engineer",
    	sayName: function(){
    		alert(this.name);
    	}
    };
    var person1 = new Person();
    person1.sayName(); //Shawnan
   
#### 原型对象的问题 ####

从上面的代码中也可以看到，原型模式没有传入参数，所以所有实例都有具有相同的属性值；并且对于包含引用类型值的属性，改变某个实例的引用类型属性值，会引起所有实例的该属性值改变。所以单独的原型模式很少在实际中得到应用。     

### 构造函数模式和原型模式组合 ###

上面我们已经了解到，构造函数模式用于定义实例属性比较合适，原型模式用于定义方法和共享的属性比较合适，所以组合使用构造函数模式与原型模式是集两种模式之长的一种方式。可以实现每个实例都有自己的一份实例属性的副本，但又同时共享着对方法的引用。例如：   

    function Person(name, age, job){
    	this.name = name;
    	this.age = age;
    	this.job = job;
    	this.friends = ["Jenny", "Zhou"];
    }
    Person.prototype = {
    	constructor: Person,
    	sayName: function(){
    		alert(this.name);
    	}
    };
    var person1 = new Person("Shawnan", 24, "Software engineer");
    var person2 = new Person("Greg", 27, "Doctor");
    person1.friends.push("Van");
    alert(person1.friends); //"Jenny, Zhou,Van"
    alert(person2.friends); //"Jenny, Zhou"
    alert(person1.friends == person2.friends); //false
    alert(person1.sayName == person2.sayName); //true
   
### 动态原型模式 ###
   
动态原型模式是对上面的组合模式进一步优化的一种方法，它把所有的信息都封装在了构造函数中，而通过在构造函数中初始化原型，又保持了同时使用构造函数和原型的优点。意思就是，通过检查某个应该存在的方法是否有效，来决定是否需要初始化原型。 
    
    function Person(name, age, job){
    	this.name = name;
    	this.age = age;
    	this.job = job;
    	this.friends = ["Jenny", "Zhou"];
    	if (typeof this.sayName != "function"){
    		Person.prototype.sayName = function(){
    			alert(this.name);
    		}
    	}
    }
   
   
# 继承 #

许多面向对象的语言都支持接口继承和实现继承两种继承方法。接口继承只继承方法签名，而实现继承则继承实际的方法。但是ECMAScript中无法实现接口继承，只支持实现继承，而且其实现继承主要是依靠原型链来实现的。

## 原型链 ##
   
构造函数、原型和实例的关系：每个构造函数都有一个原型对象，原型对象都包含一个指向构造函数的指针，而实例都包含一个指向原型对象的内部指针。   
如果我们让原型对象等于另一个类型的实例，此时的原型对象将包含一个指向另一个原型的指针，相应地，另一个原型中也包含着一个指向另一个构造函数的指针。假如另一个原型又是另一个类型的实例，那么上述关系依然成立，如此层层递进，就构成了实例与原型的链条。这就是所谓的原型链。
    
    function Father(){
    	this.name = "father";
    }
    Father.prototype.getName = function() {
    	return this.name;
    }
    function Child(){
        //this.name = "child";
    }
    Child.prototype = new Father();
    var instance = new Child();
    alert(instance.getName()); //father

上面的代码最终使得instance指向Child的原型，Child的原型指向Father的原型，考虑到默认原型，则还有Father的原型指向Object的原型。   
此时，虽然getName是Father的原型方法，但是因为其位于instance的原型链上，所以在调用getName方法时，会首先在实例中搜索该属性，如果没有找到该属性，则会继续搜索实例的原型。在通过原型链实现继承的情况下，搜素过程就会沿着原型链继续向上。所以在上面的代码中，始终会找到getName方法，此时，会再次寻找name属性，依然从实例开始向上寻找，所以此时会弹出"father"，但若是Child构造方法中的`this.name = "child";`没有被注释，则会弹出"child"。    

此时，通过instanceof操作符和isPrototypeOf()方法来检测Object、Father、Child都会返回true。因为，instance可以说是Object、Father、Child中的任何一个类型的实例，而只要是在原型链中出现过的原型，isPrototypeOf()方法都会返回true。    

此外，要注意给原型添加方法的代码一定要放在替换原先的语句之后。

### 原型链的问题 ###
   
   原型链的最主要问题也是包含引用类型值的原型，包含引用类型值的原型属性会被所有实例共享；
   原型链的第二个问题是：在创建子类型的实例时，不能像超类的构造函数中传递参数。

## 借用构造函数 ##
   
借用构造函数，也叫做伪造继承或者经典继承，这种方式的基本思想就是在子类型的构造函数内部调用超类型的构造函数。例如：
   
    function Father(name){
    	this.colors = ['red', 'blue', 'green'];
        this.name = name;
    }
    function Child(){
    	Father.call(this, "Shawnan");
    }
    var instance1 = new Child();
    instance1.colors.push('white');
    var instance2 = new Child();
    alert(instance1.colors); // 'red,blue,green,white'
    alert(instance2.colors); // 'red,blue,green'
    alert(instance1.name); // "Shawnan"


借用构造函数方式通过使用call()方法（或apply()方法），在要新创建的Child实例的环境下调用了Father构造函数，从而每一个Child对象都会初始化一个colors数组，所以Child的每个实例都会具有自己的colors属性的副本。

### 借用构造的问题 ###
   
借用构造函数的继承方式存在的问题跟构造函数模式的问题类似，方法都在构造函数中定义，无法实现函数服用，而且在超类型的原型中定义的方法，对子类型而言也是不可见的，结果所有类型都只能使用构造函数模式。因而，借用构造函数实现继承的技术也是很少单独使用的。
   
## 组合继承 ##
   
组合继承，有时候也叫做伪经典继承，指的是将原型链和借用构造函数的技术组合到一块，从而发挥二者之长的一种继承模式。其背后的思路是使用原型链实现对原型属性和方法的继承，而通过借用构造函数来实现对实力属性的继承。这样，既通过在原型上定义方法实现了函数复用，又能够保证每个实例都有它自己的属性。   
   
    function Father(name){
    	this.name = name;
    	this.colors = ['red', 'blue', 'green'];
    }
    Father.prototype.getName = function() {
    	return this.name;
    }
    function Child(name, age){
    	Father.call(this, name);
    	this.age = age;
    }
    Child.prototype = new Father();
    Child.prototype.constructor = Father;
    Child.prototype.sayAge = function(){
    	alert(this.age);
    }
    var instance1 = new Child("Shawnan", 24);
    instance1.colors.push('white');
    alert(instance1.colors); // 'red,blue,green,white'
    alert(instance1.name); //"Shawnan"
    instance1.sayAge(); //24
    
    var instance2 = new Child("Grey", 22);
    alert(instance2.colors); // 'red,blue,green'
    alert(instance2.name); //Grey
    instance2.sayAge();  //22

组合继承形式避免了原型链和借用构造函数的缺陷，融合了它们的优点，成为JavaScript中最常用的继承模式。但是，仍旧存在会调用两次超类构造函数的问题。
   
## 原型式继承 ##
   
原型式继承的想法是借助原型基于已有对象创建新对象。   
这种继承方式采用如下函数：
   
    function object(o){
    	function F(){}
    	F.prototype = o;
    	return new F();
    }
    //在object()函数内部，先创建了一个临时性的构造函数，然后传入的对象作为这个构造函数的原型，最后返回了这个临时类型的一个新实例。从本质上讲，object()对传入其中的对象执行了一次浅复制。
    var Person = {
    	name: "Shawnan",
    	friends: ["Jenny", "Mars"]
    }
    
    var anotherPerson = object(Person);
    anotherPerson.name = "Grey";
    anotherPerson.friends.push("Rob");

ECMAScript5中新增了Object.create()方法规范了原型式继承。
这种方式仍旧存在包含引用类型值的属性始终都会共享响应的值的问题。
   
## 寄生式继承 ##
   
寄生式继承是与原型式继承紧密相关的一种思路，寄生式继承的思路是创建一个仅用于封装继承过程的函数，该函数在内部以某种方式来增强对象，最后再像真地是它做了所有工作一样返回对象。
   
    function object(o){
    	function F(){}
    	F.prototype = o;
    	return new F();
    }
    function createAnother(original){
    	var clone = object(original);
    	clone.sayHi = function(){
    		alert("Hi");
    	}
    	return clone;
    }
    var Person = {
    	name: "Shawnan",
    	friends: ["Jenny", "Mars"]
    }
    
    var anotherPerson = createAnother(Person);
    anotherPerson.sayHi();

这个object()函数不是必需的，任何能够返回新对象的函数都适用于此模式。   
这种方式虽然可以为对象添加方法，但是与构造函数模式类似，仍旧无法做到函数的复用。   

## 寄生组合式继承 ##
   
虽然组合继承是JavaScript最常用的继承模式，但是它无论什么情况下都会调用两次超类构造函数；一次是在创建子类型原型的时候，一次是在子类型构造函数内部。
于是，又出现了寄生组合式继承来解决这个问题。寄生组合式，即通过借用构造函数来继承属性，通过原型链的混成形式来继承方法。其背后思路是：不必为了指定子类型的原型而调用超类型的构造函数，我们所需要的无非就是超类型原型的一个副本而已。本质上，就是使用寄生式继承来继承超类型的原型，再将结果指定给子类型的原型。    
寄生组合式继承的基本模式如下：
   
    //寄生组合式
    function inheritPrototype(subType, superType){
    	var prototype = Object(superType.prototype); //创建对象
    	prototype.constructor = subType;			 //增强对象
    	subType.prototype = prototype;				 //指定对象
    }
    function Father(name){
    	this.name = name;
    	this.colors = ['red', 'blue', 'green'];
    }
    Father.prototype.getName = function() {
    	return this.name;
    }
    function Child(name, age){
    	Father.call(this, name);
    	this.age = age;
    }
    inheritPrototype(Chile, Father);
    Child.prototype.sayAge = function(){
    	alert(this.age);
    }
    var instance1 = new Child("Shawnan", 24);
    instance1.colors.push('white');
    alert(instance1.colors); // 'red,blue,green,white'
    alert(instance1.name); //"Shawnan"
    instance1.sayAge(); //24
    
    var instance2 = new Child("Grey", 22);
    alert(instance2.colors); // 'red,blue,green'
    alert(instance2.name); //Grey
    instance2.sayAge();  //22

这个例子的高效率体现在它只调用了一次Father构造函数，并且因此避免了再Father.prototype上面创建不必要的、多余的属性。与此同时，原型链还能保持不变。因此，还能够正常使用instanceof和isPrototypeOf()。因而，被认为是引用类型最理想的继承范式。
   
    