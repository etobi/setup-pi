#!/usr/bin/env bash
# setup nagios

sudo apt-get -y install nagios-plugins
echo "
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjtS/PeZaW/4/zIERUvA2UpfeH7g5EiY+dv+3+20LL8askHNcK3YYO9MxsOEhH/rHSGp7Iv6ukaCrOqZxq6co+28/kijoj+M+y6zYFaekitgEr8wH+xN/FuZJPfPauZWD/ixvyOjJq/366+FF6WsQMqxu+0HxS76rsQ5Ed2PQP0Q2mpxm7wC2fsFPlfIck0dn3faRCyh7VdMCVMy0vtcu+dK0SbIDjWV3w9Wwk7jyNe5SPg5dGB4fiyb7Ax2N6Hlyj9QsOn6rqBNkDPud5gZ/Q2SLHK0a5yYkJWurrj+mEyWL+dkGu4yO3vcaNBEwQXXo4FbfKLtH+WP6cmr9rH3df nagios@mon-pi
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8mxQZFs1MfSE0RMs66lp13D9QUZdlnOszM3QBM5hYYkJNJ3NEHIZr2JwOaExKH3dysZy/WyKw7ypZ9nUDB8BrxNPA/o4/KWxUc7myEdQacYP3xdMFStOwDRi8fBV2V5xwCxij6ahhkCMgcT+9S31GXIust5rXg31+Sk7QJs7FI+fg9xt5xi5He2Z9DoVdHNPWh7nZLOJU4Y1UPOU+d/TA4jYofqQRRSRZdPZwJgPQsz98CPUu5NA6KDd4nPjj58v4XEkRgoyrfSuhL/m8mvjyM3AHb+B5J4RX9TA884X1+bx+kQiYBs8dYWvQSwS7gMRKfa00hLXrvPHUdCpcE+/H pi@mon-pi
" >> ~/.ssh/authorized_keys
