# 1. 安装repo
```
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
```
# 2. 从github获取
```
repo init -u https://github.com/luban003/sophon-manifest -m sdk_v1.9_manifest.xml

repo sync -j4
```
# 3. 文件结构
SDK文件结构说明如下:
![image](https://github.com/user-attachments/assets/4f72688f-6c81-4427-a9d7-47cf30eb58e1)

# 4. 从百度网盘下载SDK 编译docker
链接: https://pan.baidu.com/s/1CsYJl2zpcCobvvAkUpu3yg?pwd=q2u4 提取码: q2u4

# 5. 导入docker镜像，有导入过的可以不用操作
```
docker load -i bm1688_docker.tar
```
# 7. 运行编译容器
```
 docker run  -e LOCAL_USER_ID=`id -u $USER_ID` --privileged -v /dev:/dev -itd -v $2:/project/bm1688  bm1688_docker:latest /bin/bash
```
$2 为你repo sync 后的源码top 路径。

# 8. 编译SDK
```
source build/envsetup_soc.sh

defconfig  edge_adv_aom7260

clean_edge_all 

build_edge_all  
```
# 9. 烧录SD 卡，更新EMMC中的所有内容
将编译生成的固件，即install/soc_edge_wevb_emmc/package_edge/sdcard.tgz即是目标文件。 将其解压拷贝到tf卡根目录即可使用sd升级。
我们提供了对应脚本，用以制作SD卡， 位于images/mk-sdcard.sh. 将sdcard.tgz 拷贝至该脚本的同一目录，执行以下命令，即可完成烧录：
```
./mk-sdcard.sh /dev/sdb
```
完成SD 卡制作后，将SD 卡插入板卡，上电后系统会自动进入更新机制，将SD卡中的内容，完全更新至板卡的eMMC Flash 中。值的注意的是，eMMC 中的所有
内容会被清空（除过boot0/1 和rpmb分区）。
完成更新后，拔出SD卡，重启系统，即可使用新的系统启动。

# 10. 系统登陆
使用debug 口登陆后，系统会提示登陆，我们提供了两个账户可供登陆
linaro：linaro				
root: 默认没有密码，需要用户第一次等后，根据自己需要进行设置。			




