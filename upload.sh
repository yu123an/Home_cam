#上传图片
cropid=###############
secret_key=######################
#获取access_token
ppic=$1
access_token=$(curl "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${cropid}&corpsecret=${secret_key}" | jq -r .access_token)
#上传图片
media=$(curl "https://qyapi.weixin.qq.com/cgi-bin/media/upload?access_token=${access_token}&type=image" -F "media=@${ppic}" | jq -r  .media_id)
echo $media
#发布消息
msg=$(curl "https://qyapi.weixin.qq.com/cgi-bin/appchat/send?access_token=${access_token}" -d '
{ "chatid": "chwhsen","msgtype":"image","image":{"media_id": "'"${media}"'"},"safe":0}' | jq -r .errcode)
if [ $msg -lt 1 ]
then
rm $ppic
else
curl "https://qyapi.weixin.qq.com/cgi-bin/appchat/send?access_token=${access_token}" -d '{ "chatid": "chwhsen","msgtype":"text","text":{"content" : "This picture too big!!!"},"safe":0}' | jq .
fi
