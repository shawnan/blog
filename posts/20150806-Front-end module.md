---
title: 前端模块化
tags: javascript
date: 2015/08/06 23:11:00
---

# 前端模块化 #

前几天被问到前端模块化的问题，才发现，自己是真的不了解前端模块化，借此机会，好好的学习一下前端模块化。

### 前端模块化不等于JavaScript模块化 ###

这个概念无疑是很清楚的，因为页面上不仅仅有JavaScript代码，还有CSS和HTML代码，如果仅仅对JavaScript实现了模块化，那不能称之为前端模块化。所以，我们在考虑这个问题的时候，要从三个方面进行考虑。

<!--more-->
   
## JavaScript的模块化 ##

我对JavaScript模块化的兴趣比较大，所以先学习JavaScript模块化。

### 为什么要进行JavaScript的模块化？ ###


那么，JavaScript的模块化有什么好处呢？    
随着技术的发展，网站开发逐渐变成了Web Application的开发，所以代码复杂度逐渐提高，代码的组装变得困难，开发者需要将JavaScript的内容分离成不同的JS模块。分离成不同的模块以后，我们可以用到什么模块就加载什么模块，很方便的实现代码复用。   
采用JavaScript模块化，首先可以解决的是开发中的命名冲突问题，当一个开发团队大到一定程度时，就会出现命名冲突的问题。   
其次是文件依赖的问题，开发到一定程度，我们经常会抽象出一些公共的功能，封装成通用的组件来提高开发的效率，但是当使用的组件越来越多时，这些不同模块间的依赖问题就变得十分明显。   
除此之外，还有几个比较明显的优点。     
+ 模块的版本管理。通过别名等控制，配合构建工具，可以比较轻松的实现模块的版本管理。  
+ 提高可维护性。模块化可以让每个文件的职责单一，非常有利于代码的维护。
+ 前端性能优化。通过异步加载模块，对页面性能非常有益。可以把JavaScript文件的引入分成多个HTTP请求。

### JavaScript模块化的方法 ###

目前比较主流的JavaScript模块化方法有CommonJS的模块化规范，AMD（Asynchronous Module Definition)，CMD（Common Module Definition)等。

##### CommonJS与node.js #####

由于JavaScript官方标准定义的API是为了构建基于浏览器的应用程序，为了定义一个可以更广泛的应用程序开发的标准库，CommonJS出现了。CommonJS的的API定义了很多普通应用程序（主要指非浏览器的应用）使用的API，从而填补了这个空白。它的终极目标是提供一个类似Python，Ruby和Java标准库。这样的话，开发者可以使用CommonJS API编写应用程序，然后这些应用可以运行在不同的JavaScript解释器和不同的主机环境中。在兼容CommonJS的系统中，你可以使用JavaScript程序开发服务器端JavaScript应用程序、图形界面应用程序或者是混合应用程序。     
CommonJS和node.js的关系是一种规范与实现的关系，CommonJS是这样一种规范，NodeJS是这种规范的实现。   
在服务器端的模块化出现以后，客户端的模块化也逐渐流行起来，于是就出现了AMD规范。

##### AMD与require.js #####

Asynchronous Module Definition翻译过来就是异步模块定义，JavaScript异步加载对于页面的性能提升是非常重要的。AMD规范要求采用异步方式加载模块，模块的加载不会影响后面语句的运行，所有依赖这个模块的语句，都定义在一个回调函数中，等到加载完成以后，这个回调函数才会执行。
与CommonJS与node.js的关系类似，AMD与require.js也是一种规范与实现的关系，AMD规范就是这样一个异步模块定义的规范，require.js就是它的实现。
require.js通过异步加载解决了加载多个javaScript文件时页面失去响应的问题，同时又能管理模块之间的依赖性，便于代码的编写和维护。

##### CMD与sea.js #####

Common Module Definition意思就是通用模块定义， 在CMD规范中，一个模块就是一个文件。与AMD规范相同，CMD规范也是为了实现浏览器端的模块化开发而被提出来的，但CMD规范还是与AMD规范有些不同。   
偷取sea.js创始人的解答   
1. 对于依赖的模块，AMD 是提前执行，CMD 是延迟执行。不过 RequireJS 从 2.0 开始，也改成可以延迟执行（根据写法不同，处理方式不同）。CMD 推崇 as lazy as possible.   
2. CMD 推崇依赖就近，AMD 推崇依赖前置。看代码：                                                                                      
         
    // CMD   
    define(function(require, exports, module) {   
        var a = require('./a')
	    a.doSomething()
	    // 此处略去 100 行
	    var b = require('./b') // 依赖可以就近书写
	    b.doSomething()
	    // ... 
	})

    // AMD 默认推荐的是
    define(['./a', './b'], function(a, b) { // 依赖必须一开始就写好
        a.doSomething()
        // 此处略去 100 行
		b.doSomething()
		...
	}) 

虽然 AMD 也支持 CMD 的写法，同时还支持将 require 作为依赖项传递，但 RequireJS 的作者默认是最喜欢上面的写法，也是官方文档里默认的模块定义写法。   
3. AMD 的 API 默认是一个当多个用，CMD 的 API 严格区分，推崇职责单一。比如 AMD 里，require 分全局 require 和局部 require，都叫 require。CMD 里，没有全局 require，而是根据模块系统的完备性，提供 seajs.use 来实现模块系统的加载启动。CMD 里，每个 API 都简单纯粹。   
4. 还有一些细节差异，具体看这个规范的定义就好，就不多说了。

另外，SeaJS 和 RequireJS 的差异，可以参考：<https://github.com/seajs/seajs/issues/277>   
具体的内容待我学习sea.js后再细细品味。
