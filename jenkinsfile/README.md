### 说在前面
[Jenkins安装及使用教程](https://my.oschina.net/bxxfighting/blog/3122435)  

### 有关Jenkins
> 最初被调用搭建devops系统时，关于jenkins的知识几乎为0.  
> 然后在网上查找各种文档真是像吃屎一样.  
> 因此，我不想有兄弟再走我的老路.  
> 在研究使用jenkins时，大概分成四个阶段，每一个阶段都算是一次大的变化.  

#### 第一阶段: Freestyle Project
> 也就是jenkins创建job的第一种形式，所有内容都通过jenkins页面上配置.  
> 一开始这么弄的时候，虽然是在界面上配置, 但是我就想，一定得弄成一个比较通用或者容易修改成其它job.  
> 查看python操作jenkins的库python-jenkins，发现job是通过xml配置文件创建.  
> 并且还有接口可以获取job的xml配置文件.  
> 那么我现在的思路就是，我弄一个模板的job，通过获取模板job的xml配置文件，并修改成对应服务的信息来创建其它job  

> 这里有一个比较有意思的事情，原本我想直接弄成一个job，然后通过传各种参数实现部署不同服务的.  
> 但是需求方说参数太多不想选，最后弄成多个job后，发现job太多了，一样不好选.  
> (但是这些都不是本质问题，根本原因是缺少一个自建的管理平台来管理这些东西)  

#### 第二阶段: 声明式pipeline
```
pipeline {
}
```
> 经过几天研究后，发现可以直接通过代码的形式创建job，这样更容易管理，修改起来更方便  
> 这时候把job按语言分成了几种，不同语言有自己对应的pipeline文件.  
> 然后仍然是每种语言创建一个模板job, 之后为不同服务通过第一阶段的方式创建对应的job  
> 虽然不同服务最后的job不同，但是相同语言的服务job其实使用的是相同的pipeline的文件  
> 因此，在有修改时，直接修改对应的pipeline文件，所有job就都生效了  
> 在使用声明式pipeline开始是挺好，但是后来要增加很多功能，声明式pipeline就出现很难处理的情况  

#### 第三阶段: 脚本式pipeline
```
node('') {
}
```
> 转变成脚本式后，写很多东西就很舒服了(其实跟声明式变化不大)  
> 最主要是好处就是变量使用上更容易、更舒服  

#### 第四阶段: 脚本式pipeline之功能分离
> 其实这个是我觉得从声明式转到脚本式后，最大的好处(可能声明式也行，但我确实没有找到用法)  
> 就是把不同功能，写到不同文件中，通过组合形成最后的pipeline  
> 比如，按之前不同语言对应不同的pipeline，但是他们之间又有相同的部分.  
> 就可以把相同的部分写到一个独立的文件中，如果要用就通过load来加载它.  
> 还有一个最重要的就是，如果有了自己的运维平台管理，那么，我们就可以不再需要每个服务使用独立的job  
> 这样可以把所有都合并成一个job，那么就有一个pipeline，在里面通过if等判断加载不同的功能.  


#### 意见和建议
* 使用一个job部署所有服务?
> 虽然我上面说，可以使用同一个job部署所有服务了，这样方便维护，但是还是要看情况的  
> 如果服务很多，而且还有多个环境，一个job是在一个workspace下的，这样可能导致目录下内容过多  
> 而jenkins的管理是基于文件的，不知道对速度有影响  
> 同时，一个job虽然可以设置允许并行，但是调度肯定会对效率有影响，至少我建议，不同环境应该使用不同的job  
> 尤其是线上环境至少应该独立出来，我都想线上使用单独的jenkins服务的。  
> 因为测试环境相对来说会比线上部署频繁，使用相同的jenkins服务，可能影响线上部署的稳定  

* 使用一个job部署所有服务?
> 还是相同的问题，但是要说的东西不一样.  
> 如果我们没有一个运维平台管理，只是直接使用jenkins操作的方式。那么不建议一个job  
> 这里会涉及到权限问题.  
> 最后能根据部门划分不同的job，相同部门下，再根据不同语言划分job  
> 这样job数量也不会太多，同时也更容易实现权限管理.  
> (虽然划分成不同的job，但是使用的pipeline还是建议使用同一个，即使有什么特殊需要也可以通过按需加载实现)  

#### 依赖插件
* Build Name and Description Setter
> 因为多个服务使用同一个job，那么就需要区分哪一个任务部署的是哪一个服务  
> 因此使用此插件完成修改build任务名称及描述信息  

* HTTP Request
> 用来发送http请求  

* Pipeline Utility Steps
> 用于支持读取json/yaml等格式数据，比如用HTTP Request请求返回数据，可以用readJSON来解析成变量  
> 或者下载一个内容为yaml格式的文件，然后用readYaml来读取成变量  


示例代码:
假如现在有一个POST请求，需要json参数id和version  
返回状态码200是正常，并且返回内容中code需要为0, 否则失败  
然后正常返回后，需要返回的json格式数据解析出来使用  
```
// body数据生成，其实可以直接body = ["id": 111, "version": "1.2.4"]
// 这里只是提醒，如何弄一个空的字典，因为直接[]就是数组了，中间需要加冒号
body = [:]
body.put("id", 111)
body.put("version", "1.2.4")

url = 'http://xxx.com/xxx/'
resp = httpRequest acceptType: 'APPLICATION_JSON', \
            consoleLogResponseBody: true, \
            contentType: 'APPLICATION_JSON', \
            httpMode: 'POST', \
			// 这里是将字典转成json字符串
            requestBody: groovy.json.JsonOutput.toJson(body), \
            responseHandle: 'NONE', \
            url: url, \
			// 验证返回的http状态码必须是200
            validResponseCodes: '200', \
			// 验证返回的内容中code必须为0
            validResponseContent: '"code": 0', \
            wrapAsMultipart: false
// 通过readJSON解析json数据
data = readJSON text: resp.content
result = data.data
code = data.code
```
