# ThoughtWorks   
Homework for ThoughtWorks   
Get Ready!

# 中文说明：

1: 严格按照需求文档进行编写程序。所有控件均原生编写，没有采用第三方库。   
2: 网络请求包括数据请求和图片请求，用GCD进行控制。   
3: 缓存机制。图片请求时，先判断该图片是否在缓存中心存在，如果存在就直接使用，如果不存在，就接着查找本地沙盒文件系统，如果存在就直接读取，存入缓存中心，如果还不存在，就启动线程进行下载。其中缓存中心采用先入先出机制，对内存缓存进行控制。   
4: 图片显示。根据不同需求，在显示前，当tweet里只有一张图片时，等比处理并显示；当有多张图片时，缩放并裁剪中心区域进行显示，控制内存大小并保证图片质量。当下载失败时显示刷新按钮，可点击重新加载。   
5: TableView原生上拉加载更多，下接刷新。内容动态计算。   
6: 工程源码Git控制。Github: https://github.com/wayde191/ThoughtWorks ; 欢迎查阅。   
7: 视频真机Demo下载地址：http://pan.baidu.com/s/1i3h90PJ   
8: 生产开发环境切换 AppConf->AppConfig.h : APP_PRODUCTION_ENVIRONMENT。当需要查看log时，可以打开此宏。   
9: 测试用例有添加，但还需要完善。   
10: 没有使用nibs, storyboards   
11: ios 7.0以上   

# English description：
=========== Network ===========   
1: Setup network monitor, because we need to observer network status   

// Test log below   
2015-04-04 23:36:49.885 WeChatMoments[11926:65565] Reachability Flag Status: -R -----l- networkStatusForFlags   
2015-04-04 23:36:49.885 WeChatMoments[11926:65565] -[TWNetworkMonitor updateNetwordStatus:](92): wifi   
2015-04-04 23:38:12.245 WeChatMoments[11926:65565] Reachability Flag Status: -R tc----- networkStatusForFlags   
2015-04-04 23:38:12.245 WeChatMoments[11926:65565] -[TWNetworkMonitor updateNetwordStatus:](92): unavailable   
2015-04-04 23:38:18.019 WeChatMoments[11926:65565] Reachability Flag Status: -R ------- networkStatusForFlags    

2: Do HTTP request and parse the data according to the type of response. Get data ready!   
Added Test case suit named: NetworksTests (Needs to fill it up with lots of other details test cases)   

3: Image cache mechanism (GCD)   
---> Get image from memeory, then next...      
---> Get image from local file system, them next...   
---> Get image from internet...   

=========== UIView ===========    
1: TableView pull down to refresh   
2: TableView pull up to loading more   
3: TWImageView loading image form internet if the image not found in cache mechanism. If loaded failed, you can click the refresh button to try again   
