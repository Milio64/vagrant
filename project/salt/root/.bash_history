salt '*' salt.state 
salt '*' saltutil.refresh_pillar
salt '*' pillar.items
salt '*' state.highstate
salt '*' state.highstate saltenv=base
cat /etc/os-release 
dnf refresh
dnf update -y
salt '*' state.highstate saltenv=base
salt '*' state.highstate saltenv=prod
ll
salt '*' state.highstate saltenv=prod
salt '*' state.highstate saltenv=base
ll
salt '*' state.highstate saltenv=base
salt '*' state.highstate saltenv=prod
#1663230058
cd salt-multi/
#1663230062
ll
#1663230067
git pull
#1663230088
git branch --set-upstream-to=origin/<branch> main
#1663230096
git branch --set-upstream-to=origin/main main
#1663230152
ll
#1663230212
echo "# test" >> README.md
#1663230212
git init
#1663230212
git add README.md
#1663230212
git commit -m "first commit"
#1663230212
git branch -M main
#1663230212
git remote add origin git@github.com:Milio64/salt-multi.git
#1663230214
git push -u origin main
#1663230286
git config --global user.email "milioanis@gmail.com"
#1663230286
git config --global user.name "milio
git push -u origin main
#1663230318
git config --global user.name "milio"
#1663230325
git push -u origin main
#1663230599
ll
#1663230604
git init
#1663230614
git clone git@github.com:Milio64/salt-multi.git
#1663231861
ll
#1663231889
salt '*' state.highstate saltenv=prod
#1663231902
salt '*' state.highstate saltenv=base
#1663231917
salt '*' pillar.items
#1663231940
salt '*' pillar.items saltenv=prod
#1663232318
/vagrant/multi.sh 
#1663232340
sh /vagrant/multi.sh 
#1663232421
salt '*' pillar.items saltenv=pro[B
#1663232427
10:59:51 root@salt salt-multi ±|master ✗|→ salt '*' pillar.items saltenv=pro
#1663232436
salt '*' saltutil.refresh_pillar
#1663232454
salt '*' pillar.items saltenv=prod
#1663232529
dnf install mc
#1663232562
mc
#1663232743
systemctl restart salt-master.service 
#1663232752
salt '*' pillar.items saltenv=prod
#1663232822
salt '*' pillar.items saltenv=base
#1663232839
salt '*' pillar.items pillarenv=base
#1663232847
salt '*' pillar.items pillarenv=prod
#1663240321
c
#1663240325
cd /
#1663240330
systemctl restart salt-master.service 
#1663240359
systemctl status salt-master.service 
cd salt-multi
mkdir salt-multi
cd salt-multi
git init
git remote add origin git@github.com:Milio64/salt-multi.git
git branch -M main
git pull
git branch --set-upstream-to=origin/<branch> main
cd ..
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
#1663320272
systemctl restart salt-master.service 
#1663320298
systemctl status salt-master.service 
#1663320476
systemctl restart salt-master.service 
#1663320479
systemctl status salt-master.service 
#1663320526
salt '*' state.highstate saltenv=base
#1663320533
salt '*' state.highstate saltenv=prod
#1663320681
salt '*' state.highstate saltenv=base
#1663320716
salt '*' pillar.items saltenv=prod
#1663320722
salt '*' pillar.items saltenv=base
#1663321074
systemctl restart salt-master.service 
#1663321087
systemctl status salt-master.service 
#1663321129
systemctl restart salt-master.service 
#1663321132
systemctl status salt-master.service 
#1663321141
salt '*' state.highstate saltenv=base
#1663321157
updatedb
#1663321172
locate main.sls
#1663321179
locate top.sls
#1663321232
cd /var/cache/salt/minion/files/base/
#1663321234
ll
#1663321246
cd /var/cache/salt/master
#1663321247
ll
#1663321257
cd roots
#1663321258
ll
#1663321261
cd hash
#1663321262
ll
#1663321266
cd prod
#1663321271
ll
#1663321307
pwd
#1663321436
salt '*' state.highstate saltenv=base
#1663361100
pwd
#1663361109
cd /var/cache/salt/master
#1663361111
ll
#1663361121
cd roots/
#1663361123
ll
#1663361130
cd hash/
#1663361131
ll
#1663361178
systemctl restart salt-master.service 
#1663361184
salt '*' state.highstate saltenv=base
#1663361203
salt '*' state.highstate saltenv=prod
#1663361210
salt '*' state.highstate 
#1663361242
less /var/log/salt/master 
#1663361306
systemctl status salt-master.service 
#1663508321
salt '*' state.highstate 
#1663508346
systemctl restart salt-master.service 
#1663508356
systemctl status salt-master.service 
#1663508372
systemctl stop salt-master.service 
#1663508377
systemctl status salt-master.service 
#1663508385
systemctl start salt-master.service 
#1663508388
systemctl status salt-master.service 
#1663508412
salt '*' state.highstate 
#1663508489
systemctl stop salt-master.service 
#1663508498
systemctl start salt-master.service 
#1663508502
systemctl status salt-master.service 
#1663508543
systemctl restart salt-master.service 
#1663508546
systemctl status salt-master.service 
#1663508553
salt '*' state.highstate 
#1663508583
systemctl status salt-master.service 
#1663508601
systemctl start salt-master.service 
#1663508603
systemctl status salt-master.service 
#1663508714
reboot
#1663508878
systemctl restart salt-master.service 
#1663508881
systemctl status salt-master.service 
#1663508937
systemctl restart salt-master.service 
#1663508941
systemctl status salt-master.service 
#1663509080
systemctl restart salt-master.service 
#1663509088
systemctl status salt-master.service 
#1663509134
rm /var/cache/salt/master/gitfs/ff77aa54548939adf6578d6455a7f575f16cbe721d94c8d5d4210c21407da164/.git/update.lk
#1663509137
systemctl restart salt-master.service 
#1663509142
systemctl status salt-master.service 
#1663509161
salt '*' state.highstate 
#1663519111
/var/cache/salt/master/gitfs/ff77aa54548939adf6578d6455a7f575f16cbe721d94c8d5d4210c21407da164/.git/update.lk
#1663519111
Total states run:     1
#1663519111
Total run time:   0.000 ms
#1663519117
vagrant halt
#1667577191
cat /etc/os-release 
#1667577201
dnf install git
#1668090690
systemctl restart salt
#1668090700
systemctl restart salt-master.service 
#1668090708
systemctl status salt-master.service 
#1668090731
q
#1668090734

#1668090743
salt-run fileserver.file_list
#1668090923
systemctl status salt-master.service 
#1668090945
systemctl stop salt-master.service 
#1668090950
systemctl start salt-master.service 
#1668090953
systemctl status salt-master.service 
#1668090961
salt-run fileserver.file_list
#1668090986
dnf install git
#1668091027
git clone https://gitlab.com/RILP/saltstack
#1668091056
ll
#1668091082
cd saltstack/
#1668091084
ll
#1668091940
grep -v '^$\|^\s*#' master
#1668091947
cd ..
#1668091952
ll
#1668091964
cd /etc/salt
#1668091966
grep -v '^$\|^\s*#' master
#1668091969
ll
tail -f setup.log 
ll
tail -f setup.log 
systemctl restart salt-master.service 
systemctl status salt-master.service 
systemctl restart salt-master.service 
systemctl status salt-master.service 
systemctl restart salt-master.service 
systemctl status salt-master.service 
dnf install -y git
systemctl restart salt-master.service 
systemctl status salt-master.service 
systemctl restart salt-master.service 
systemctl status salt-master.service 
dnf install -y mc
systemctl restart salt-master.service 
systemctl status salt-master.service 
history
salt '*' state.highstate saltenv=base
salt-run fileserver.file_list
salt-key
salt-key -L
salt-key -A
salt-key -L
