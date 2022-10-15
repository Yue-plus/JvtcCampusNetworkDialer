#!/usr/bin/env bash

# 九江职业技术学院（濂溪校区）校园网一键登入
# 也可以通过浏览器登入，请访问：http://10.31.0.10/a79.htm

# 认证主机
AUTH_HOST='10.31.0.10:801'

# 账号 [学号@运营商代码]
# - 电信为：`@telecom`
# - 联通为：`@unicom`
# - 移动为：`@cmcc`
USER_ACCOUNT='000000000@telecom'

# 密码
USER_PASSWORD='000000'

curl "http://${AUTH_HOST}/eportal/portal/login?user_account=${USER_ACCOUNT}&user_password=${USER_PASSWORD}"