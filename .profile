drs(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
sudo dirsearch -u $1 -e -b $2 -t 50 -e sh,txt,php,html,htm,zip,tar.gz,tar -x 400,403,404 --plain-text-report=$1_dirs;
}

fastrecon(){ # fastrecon example.com
mkdir ~/Recon/$1; cd ~/Recon/$1;
subfinder -d $1 -silent -o $1_domains;
naabu -hL $1_domains -silent -t 30 -o $1_ports;
cat $1_ports | httprobe -c 30 > $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/subdomain-takeover/ -o $1_takeovers -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/basic-detections/ -o $1_basic -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/cves/ -o $1_cves -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/dns/ -o $1_dbs -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/files/ -o $1_files -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/panels/ -o $1_panels -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/security-misconfiguration/ -o $1_security -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/technologies/ -o $1_technologies -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/tokens/ -o $1_token -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/vulnerabilities/ -o $1_vuln -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/workflows/ -o $1_workflows -l $1_schemes;
dnsprobe -l $1_domains -o $1_ips -silent;
dnsprobe -l $1_domains -r CNAME -o $1_cnames -silent;
cat $1_schemes | aquatone -out $1_takeover_screen;
cat $1_domains | aquatone -out $1_domains_screen;
echo "Scan All Url";
cat $1_domains | sudo gau > $1_domains_allurl
}

ams(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
amass enum -d $1 -json $1.json
jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1_domainlist
}

nmapfast(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
nmap -A -Pn -T4 $1 --min-rate 100 -v -oN $1_nmap;
}

virtualmachine(){ #Run VirtualBox in background
VBoxManage startvm $1 --type headless
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


