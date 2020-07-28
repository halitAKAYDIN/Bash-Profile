drs(){
sudo dirsearch -u $1 -e $2 -t 50 -b 
}

nmapspeed(){
nmap -A -Pn -T4 $1 --min-rate 100 -v -oN /tmp/$1; printf "\n\nNmap out scan /tmp/"$1; echo
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

ams(){ #runs amass passively and saves to json
amass enum --passive -d $1 -json $1.json
jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1-domains.txt
}

crtshdrs(){ #gets all domains from crtsh, runs httprobe and then dir bruteforcers
curl -s https://crt.sh/?q\=%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe -c 50 | grep https | xargs -n1 -I{} python3 ~/tools/dirsearch/dirsearch.py -u {} -e $2 -t 50 -b 
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

v(){
vim
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
