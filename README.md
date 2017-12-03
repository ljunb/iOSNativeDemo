## 原生iOS工程集成React Native

不得不说，现在加入到 React Native 开发行列的人已经是越来越多了。还记得自己当时刚入坑那会，网上资料特别少，基本是跟着江大大的技术博客和中文网，以及鬼谣的一本书来学习的，有时遇到红屏要找很久才能找到解决方案。现在社区也相当活跃，😶😶问答QQ群也很多，氛围确实比以前要好很多。

本篇主要是针对原生移动开发方向的小伙伴，目的是梳理如何在原生工程中去集成 React Native 依赖，如何从原生界面跳转到不同的 React Native 界面，以及两者之间的数据交互、事件传递等等。以下基本是自己在公司项目中的实践经验，不一定适合每个开发团队，但是基本的应用模式应该是不变的。

### 1、集成
iOS原生项目大部分用 Cocoapods 来管理第三方库，当然也有部分是没有的，针对这两种情况，当前有两种在原生工程中集成 React Native 的方式，下面是相关的文章链接：
> * React Native 中文网的 [CocoaPods](http://reactnative.cn/docs/0.50/integration-with-existing-apps.html#content) 方式
> * 江清清技术博客中的[手动方式](http://www.lcode.org/react-native-integrating/)

Cocoapods 的方式我没有尝试过，目前接手的公司项目，都是通过手动方式来集成的。一直以为这种文档式指导的集成，是没有什么困难的。不过在写这个 demo 的时候，发现手动集成时还是遇到了一些坑，做以下总结：
> 1. 编译时提示 React Native 的一些头文件找不到
> 2. 编译时报很多以下类型的错误：`Undefined symbols for architecture x86_64:
"std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >::__grow_by(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long)", referenced from:...`
> 3. 编译正常，运行时提示：`No bridge implementation is available, giving up.` 
> 4. 如果以上一切都OK，工程运行后进入 React Native 界面时，提示：`No bundle URL present`

对应的解决方案（个人而言）：
> 1. 选择工程停止按钮旁边的 `Set the active scheme` 为 `React` ，编译成功之后，再重新选择项目同名scheme进行编译
> 2. `TARGETS` → 选中工程同名 target → `Build Phases` → `Link Binary With Libraries` → 点击"+"添加 `libstdc++` 标准库
> 3. `TARGETS` → 选中工程同名 target → `Build Settings` → `Other Linker Flags` → 点击"+"添加 `-ObjC`
> 4. 关于这个问题网上有很多解答，主要是因为各自导致的原因都不一样。而在自己本次集成中，遇到的问题，实际上是因为没有在 `Info.plist` 文件中添加 `App Transport Security Settings` ，同时在该条目下添加 `Allow Arbitrary Loads` ，并设置为 `YES` 。实际出现该问题时，Xcode 的日志中会有提示：`
App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.`

### 2、关于页面展示
React Native 应用通过 `AppRegistry` 的 `registerComponent` 方法来注册组件，`RCTRootView` 初始化实例时，都会传入一个 `moduleName` ，这个名称即是作为 `registerComponent(appKey, component, section?)` 方法的 `appKey`，与后面的 `component` 一一匹配。有时运行项目时提示 `Application xxx has not been registered.`，基本可以认为是以下两点导致：
> 1. 初始化 `RCTRootView` 实例时，传入的 `moduleName` 与 `appKey` 不一致
> 2. 运行了多个工程，导致 `packager` 不对应

相应解决方案：
> 1. 修改两者一致即可，不一定与工程名称保持一致
> 2. `packager`不对应，自然也无法注册到对应的组件，此时只要关掉 `packager`，重新在正确的项目根目录下重启 `packager` 即可


#### 2.1、基于初始参数`initialProperties`
官方的初始示例中，通过以下方式来加载一个 `RCTRootView`：
```
// AppDelegate.m

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ...
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"iOSNativeDemo"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  ...
  rootViewController.view = rootView;
  ...
}
```
在 JavaScript 中：
```
// index.js

import { AppRegistry } from 'react-native';
import App from './App';

AppRegistry.registerComponent('iOSNativeDemo', () => App);
```
上面的式很好理解：我们要显示一个写好的 React Native 页面，比如上面的 `App` ，约定好 `appKey` 与 `moduleName` 保持一致即可，做到这点就已经是完成了。不过项目中有时需要不止一个页面，如何来处理呢？这里先介绍的是通过 `initialProperties` 这个参数。我们可以通过字面量生成一个字典，将其作为 `initialProperties` 参数在生成`RCTRootView`时传入，那么在 JavaScript 中就可以通过 `this.props` 来获取，然后根据不同值显示对应的 React Native 页面。

新建一个 `RNViewController` 来加载 React Native 页面，并提供一个 `- initWithPageName:` 初始化方法，这样在从其他原生界面跳转时，加以参数来区分不同界面。其 `.m` 文件稍微详细实现为：
```
// RNViewController.m

- (instancetype)initWithPageName:(NSString *)pageName {
    self = [super init];
    if (self) {
        _pageName = pageName;
        _initialProperties = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configInitialProperties];
    [self setupRootView];
}

- (void)configInitialProperties {
    // 设置pageName
    [self.initialProperties setObject:self.pageName forKey:PAGE_NAME_KEY];
    
    // 其他配置，如读取本地保存的用户信息等...
}

- (void)setupRootView {
    NSURL *jsCodeLocation;
    
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"iOSNativeDemo"
                                                 initialProperties:self.initialProperties
                                                     launchOptions:nil];
    self.view = rootView;
}
```
内部持有的 `pageName` 和 `initialProperties` 是为了在其他地方更方便地引用和设置。然后再过来处理 JavaScript 这端：
```
 // App.js
 
import React, { Component } from 'react';
 
const router = {
  'PageA': require('./page/PageA').default,
  'PageB': require('./page/PageB').default,
};
 
export default class App extends Component {
  render() {
    const routerKey = this.props[PAGE_NAME];
    const Component = router[routerKey];
    return <Component {...this.props}/>;
  }
}
```
`router` 如何配置只取决于团队习惯，`PAGE_NAME` 也只是为了避免因为手误而出现拼写问题，所以才在入口文件 `index.js` 中配置成全局变量，这一切也是基于团队事先做好的约定。

#### 2.2、基于组件名称`moduleName`
由于只要确保创建实例时的 `moduleName` 与 `registerComponent` 中的 `appKey` 参数保持一致，就能正确加载对应的组件，所以可以通过这个 `moduleName` 来实现我们的目的。实际上这两种方式可以同时使用，不过还是建议项目中统一采用其中一种即可。
新建一个 `RNModuleViewController` 用于演示，并完善其 `.m` 文件，只罗列与第一种方式不同的代码：
```
// RNModuleViewController.m

- (void)setupRootView {
    NSURL *jsCodeLocation;
    
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:self.pageName
                                                 initialProperties:self.initialProperties
                                                     launchOptions:nil];
    self.view = rootView;
}
```
`pageName` 属性依然会配置到 `self.initialProperties` 中作为初始参数，以便在 JavaScript 中使用，这个以业务情况为准。当前的方式修改了 `moduleName` 传入的值，直接引用了 `self.pageName`，在 JavaScript 端：
```
// index.js
import { AppRegistry } from 'react-native';

// 不同appKey方式
AppRegistry.registerComponent('PageC', () => require('./page/PageC').default);
AppRegistry.registerComponent('PageD', () => require('./page/PageD').default);

```
通过这种方式的加载，并不需要像第一种 `<Component {...this.props}/>` 的写法，在组件内直接可以用 `this.props` 方式来获取初始参数。

#### 2.3、更优的加载方式
以上两种方式，可以但不限于同个 `UIViewController` 来加载所有 React Native 界面，完全可以根据业务情况，来创建独立的 `UIViewController` 加载对应的 React Native 界面。除此之外，可参考我的另外一篇文章[混编下的RCTRootView加载方式](https://github.com/ljunb/rn-relates/issues/2)，通过一个单例 `RCTBridge` ，来加载不同的 `RCTRootView` ，这或许是更好的实践方式。

### 3、Demo运行
```
$ git clone https://github.com/ljunb/iOSNativeDemo.git
$ cd iOSNativeDemo
$ npm install
$ react-native run-ios
```

### 4、TODO
- [ ] 原生与JavaScript的事件传递
