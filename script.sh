yum update
yum install httpd -y
systemctl enable httpd
systemctl restart httpd
yum install -y mutt
mkdir /home/devops
cd /home/devops
cat > metadata.sh << _EOF_
#!/bin/bash
echo "<!DOCTYPE html>"
echo "<html>"
echo "<body>"
echo "<h2>Instance Id = $(curl "http://169.254.169.254/latest/meta-data/instance-id")</h2>"
echo "<h2>MAC = $(curl "http://169.254.169.254/latest/meta-data/mac")</h2>"
echo "<h2>IP = $(curl "http://169.254.169.254/latest/meta-data/public-ipv4")</h2>"
echo "</body>"
echo "</html>"
_EOF_
sh metadata.sh >/var/www/html/index.html

cat > monitoring.sh <<__EOF__
#!/bin/bash
code=$(echo "$(curl -s -o /dev/null -w "%{http_code}" http://{$(curl "http://169.254.169.254/latest/meta-data/public-ipv4")}/)")
success=200
echo "$(echo "success $($success)")"
echo "$(echo "code $code")"
if [ $(echo "$("$code")" -ne 200 ]
then
        echo "health-check has failed" | mutt -s "Health-Check" narangshreyansh11@gmail.com
fi
__EOF__

chmod 777 metadata.sh monitoring.sh
crontab<<_eof_
@reboot sh /home/devops/metadata.sh
*/5 * * * * sh /home/devops/monitoring.sh
_eof_
