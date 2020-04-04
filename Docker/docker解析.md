### Docker介绍
-

最早的时候docker就是一个开源项目，主要由docker公司维护。
2017年年初，docker公司将原先的docker项目改名为moby，并创建了docker-ce和docker-ee

这三者的关系是：
moby是继承了原先的docker的项目，是社区维护的的开源项目，谁都可以在moby的基础打造自己的容器产品docker-ce是docker公司维护的开源项目，是一个基于moby项目的免费的容器产品, docker-ee是docker公司维护的闭源产品，是docker公司的商业产品。


-

### centos7 安装docker 

1 yum install docker-io   ---- 安装docker仓库(仓库可以包含多个容器)

2 yum list installed |grep docker ---- 列出yum中已经安装的所有的docker文件 

3 systemctl start docker  ---- 启动docker

4 systemctl status docker  --- 查看docker仓库状态

5 docker container ls -a  --- 列出docker所有容器

6 docker images  ----  查看已经下载的镜像文件安装包

7 创建dockerfile文件,并对dockerfile文件进行配置,  配置中包含一些的基本dockerfile指令

8 Dockerfile 详细介绍: &nbsp;(其中镜像、容器和 Dockerfile 。我们使用 Dockerfile 定义镜像，依赖镜像来运行容器)

- Docker 镜像是一个特殊的文件系统，除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。镜像不包含任何动态数据，其内容在构建之后也不会被改变。

- 镜像的定制实际上就是定制每一层所添加的配置、文件。
   如果我们可以把每一层修改、安装、构建、操作的命令都写入一个脚本，
   用这个脚本来构建、定制镜像，那么之前提及的无法重复的问题、镜像构建透明性的问题、体积的问题就都会解决。
   这个脚本就是 Dockerfile。

- Dockerfile 是一个文本文件，其内包含了一条条的指令(Instruction)，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。
   有了 Dockerfile，当我们需要定制自己额外的需求时，只需在 Dockerfile 上添加或者修改指令，重新生成 image 即可，省去了敲命令的麻烦。


- Dockerfile 分为四部分：基础镜像信息、维护者信息、镜像操作指令、容器启动执行指令。
   1 一开始必须要指明所基于的镜像名称，
   2 接下来一般会说明维护者信息；
   3 后面则是镜像操作指令，例如 RUN 指令。每执行一条RUN 指令，镜像添加新的一层，并提交；
   4 最后是 CMD 指令，来指明运行容器时的操作命令。

-  Docker 守护进程会一条一条的执行 Dockerfile 中的指令，而且会在每一步提交并生成一个新镜像，最后会输出最终镜像的ID。
    生成完成后，Docker 守护进程会自动清理你发送的上下文。
    Dockerfile文件中的每条指令会被独立执行，并会创建一个新镜像，RUN cd /tmp等命令不会对下条指令产生影响。
    Docker 会重用已生成的中间镜像，以加速docker build的构建速度。以下是一个使用了缓存镜像的执行过程：


FROM : 指定来源于哪个镜像  &nbsp;&nbsp;&nbsp;&nbsp;RUN 镜像执行操作指令
   
CMD  来指明运行容器时的操作命令 &nbsp; &nbsp; &nbsp; &nbsp;  ENV为后续的RUN提供环境变量
   
ADD将本地的一个文件或目录拷贝到某个目录里 

EXPOSE &nbsp; 22 &nbsp; 80 &nbsp; 8443用来指定要映射出去的端口

WORKDIR为后续RUN,CMD,ENTRYPOINT指定工作目录



#### Docker中打镜像

1 cd etc/docker/

2 vim  daemon.json

3 修改为:
{
  "registry-mirrors": ["http://registry.docker-cn.com "]
}

...

6 docker 登录 daocloud.io镜像仓库命令：
  docker login daocloud.io


7 给镜像打标签 

docker tag <your-image> daocloud.io/carmack_team/<your-image>:<tag>

例子： docker tag myhello daocloud.io/carmack_team/myhello:v1


8 上传镜像

docker push daocloud.io/carmack_team/<your-image>:<tag>

例子： docker push daocloud.io/carmack_team/myhello:v1


9 从服务器拉取镜像并运行容器

例子： docker run -p 4000:80 daocloud.io/carmack_team/myhello:v1
























