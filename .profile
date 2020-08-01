drs(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
sudo dirsearch -u $1 -e -b $2 -t 50 -e sh,txt,php,html,htm,zip,tar.gz,tar -x 400,403,404 --plain-text-report=$1_dirs;
}

fastrecon(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
subfinder -d $1 -silent -o $1_domains;
naabu -hL $1_domains -silent -t 30 -o $1_ports;
cat $1_ports | httprobe -c 30 > $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/subdomain-takeover/detect-*.yaml -silent -o $1_takeovers -l $1_schemes;
dnsprobe -l $1_domains -o $1_ips -silent;
dnsprobe -l $1_domains -r CNAME -o $1_cnames -silent;
cat $1_schemes | aquatone -out $1_takeover_screens;
cat $1_domains | aquatone -out $1_domains_screens;
}

ams(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
amass enum -d $1 -json $1.json
jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1_domains
}

nmapfast(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
nmap -A -Pn -T4 $1 --min-rate 100 -v -oN $1_nmap;
}

pingfast(){
ping -c 5 $1
}

fm(){ #command file manager
if [ "~/go/bin/lf" ] ; then
 lf
else
 go get -u github.com/gokcehan/lf && lf
fi
}

sp(){ #spotify cli
if [ "~/.local/bin/spotifycli" ];
then
 spotifycli
else
 pip install spotify-cli-linux && spotifycli
fi
}

myip(){
curl http://ipinfo.io/$1; echo
}

ncx(){
nc -l -n -vv -p $1 -k
}

s3ls(){
aws s3 ls s3://$1
}

s3cp(){
aws s3 cp $2 s3://$1 
}

ports(){
netstat -tulanp
}


twitch(){
streamlink --twitch-disable-ads https://www.twitch.tv/$1 best
}

rot3(){
 tr 'd-za-cD-ZA-C' 'a-zA-Z'
}

rot7(){
 tr 'h-za-gH-ZA-G' 'a-zA-Z'
}


rot13(){
 tr 'n-za-mN-ZA-M' 'a-zA-Z'
}


