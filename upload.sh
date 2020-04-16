#上传图片
cropid=###############
secret_key=######################
Tg_key=#######################
Group_id=####################
#获取access_token
ppic=$1
access_token=$(curl "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$cropid&corpsecret=$secret_key" | jq -r .access_token)
#上传图片
media=$(curl "https://qyapi.weixin.qq.com/cgi-bin/media/upload?access_token=$access_token&type=image" -F "media=@$ppic" | jq -r  .media_id)
echo $media
#发布消息
msg=$(curl "https://qyapi.weixin.qq.com/cgi-bin/appchat/send?access_token=$access_token" -d '
{ "chatid": "chwhsen","msgtype":"image","image":{"media_id": "'"$media"'"},"safe":0}' | jq -r .errcode)
if test $msg -lt 1 
then
	rm $ppic
else
	curl "https://qyapi.weixin.qq.com/cgi-bin/appchat/send?access_token=$access_token" -d '{ "chatid": "","msgtype":"text","text":{"content" : "This picture too big!!!"},"safe":0}' | jq .
fi

#上传视频
#获取access_token
ppic=$1
access_token=$(curl "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$cropid&corpsecret=$secret_key" | jq -r .access_token)
#上传图片
#curl "https://qyapi.weixin.qq.com/cgi-bin/media/upload?access_token=${access_token}&type=file" -F "media=@${ppic}" | jq -r  .
media=$(curl "https://qyapi.weixin.qq.com/cgi-bin/media/upload?access_token=$access_token&type=file" -F "media=@$ppic" | jq -r  .media_id)
echo $media
#发布消息
msg=$(curl "https://qyapi.weixin.qq.com/cgi-bin/appchat/send?access_token=$access_token" -d '
{ "chatid": "","msgtype":"file","file":{"media_id" : "'"$media"'"}' | jq -r .errcode)
if test $msg -lt 1 
then
	rm $ppic
else
	mmsg=$(curl "https://api.telegram.org/bot$Tg_key/senddocument" -F "chat_id=$Group_id" -F "disable_notification=true" -F "caption=`date`" -F "document=@$ppic" | jq -r .ok)
	if test $mmsg == true 
	then
		curl "https://qyapi.weixin.qq.com/cgi-bin/appchat/send?access_token=$access_token" -d '{ "chatid": "","msgtype":"text","text":{"content" : "This movie has send to tg!!!"},"safe":0}' | jq .
		rm $ppic
	else
		curl "https://qyapi.weixin.qq.com/cgi-bin/appchat/send?access_token=$access_token" -d '{ "chatid": "","msgtype":"text","text":{"content" : "我太难了!!!"},"safe":0}' | jq .
	fi
	f
