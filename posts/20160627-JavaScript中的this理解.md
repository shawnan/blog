---
title: 对JavaScript中的this理解
date: 2016/06/27 23:11:00
---

## JavaScript中的this理解
在进行今天学习之前，我对JavaScript中的this认识是比较浅显的，阅读了相关的几篇文章以后，算是有了一个相对之前更系统的认识。
现在，我认为可以把JavaScript中的this分为以下几种情况：
<div></div>
### 1、全局环境中，this指向window。

    var name = "window";
    console.log(this.name); // window

<!-- more -->
###    2、函数中，this指向函数的调用者。
##### 2.1、在作为对象的方法调用时，函数中的this指向调用对象。

    var person = {
    name: "shawnan",
    sayName: function(){
        console.log(this.name);
    }
    }
    person.sayName(); // shawnan
    
#### 2.2、所以全局函数中的this指向window；

    var name = "window";
    function changeName(){
        this.name = "newName";
    }
    changeName();
    console.log(name); // newName

#### 2.3 特殊情况
但是JavaScript中有一种特殊情况是内部函数，内部函数中的this始终指向window，这也就是我们为什么要在构造函数和原型方法在采用that提前保存this，因为不保存的话，该函数被调用时this指向了window，再访问定义在原型里面的属性的时候就会访问到window。

    var name = "window";
    var person = {
        name: "shawnan",
        sayName: function(){
            function changeName(){
                    console.log(this.name); 
                    this.name = "anotherName";
            }
            changeName();//window
            console.log(this.name);
        }
    }
    person.sayName(); // shawnan
    console.log(this.name); //anotherName

    ----------------------------------------------------------------

    var name = "window";
    var person = {
        name: "shawnan",
        sayName: function(){
            var that = this;
            function changeName(){
                    console.log(that.name); 
                    that.name = "anotherName";
            }
            changeName();//shawnan
            console.log(this.name);
        }
    }
    person.sayName(); // anotherName
    console.log(this.name); //window


#### 3、构造函数中，this指向的是新构造的对象。

    function Person(name){
        this.name = name;
    }
    var p = new Person("shawnan");
    console.log(p.name);

### 4、apply和call中，this指向其第一个参数。

    var p1 = {
        name: 'p1',
        sayName: function(){
            console.log(this.name);
        }
    };
    var p2 = {
        name: 'p2',
        sayName: function(){
            console.log(this.name);
        }
    }
    p1.sayName(); // p1
    p2.sayName(); // p2
    p2.sayName.apply(p1);  // p1


脑海中的this差不多就理解到这里，此外今天在学习的过程中也涉及到了JavaScript执行环境和变量作用域的问题，虽然还没有理解太清楚，但是可以做一个小小的总结。   
JavaScript函数执行的时候就会进入一个环境，因为JavaScript中没有块级作用域的概念，所以{}括起来的内容并没有自己的作用域，而只有函数才有作用域的概念。同时，函数能够访问外面的变量，但是外面访问不到函数内的变量，所以函数查找变量的时候会一级一级往上找，首先在函数内部查找，如果没有则到上一级函数内查找，直到找到，若到全局环境都没有找到则爆出未定义错误。当我学习到这个地方的时候，我想到了JavaScript中的原型链，感觉跟此处十分的相似，于是我就想到，如果一个对象寻找变量是先到原型链中寻找还是先到作用域链中寻找？做了一下实验我才明白，我把这两个东西搞混了，原型链是对象中存在的，用来查找对象属性的，而作用域链是用在执行环境中，用来解析变量的，二者没有什么直接的关联。对象中查找属性的时候查找到Object的原型链就会结束了，如果此时还没有找到就会返回undefined，而不会向上一级作用域去寻找。此外两者还有一个不同是变量会报未定义错误，而属性会返回undefined。
