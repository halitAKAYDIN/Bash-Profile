drs(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
sudo python3 ~/.local/bin/dirsearch/dirsearch.py -u $1 -b -f -l -r -e sh,txt,php,html,htm,zip,tar.gz,tar,json -x 400,403,404 --plain-text-report=$1_dirs;
}

fastrecon(){
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
nuclei -c 30 -t ~/nuclei-templates/technologies/ -o $1_technologies -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/tokens/ -o $1_token -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/vulnerabilities/ -o $1_vuln -l $1_schemes;
nuclei -c 30 -t ~/nuclei-templates/workflows/ -o $1_workflows -l $1_schemes;
dnsprobe -l $1_domains -o $1_ips -silent;
dnsprobe -l $1_domains -r CNAME -o $1_cnames -silent;
cat $1_schemes | aquatone -out $1_takeover_screen;
cat $1_domains | aquatone -out $1_domains_screen;
}

nmapfast(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
nmap -A -Pn -T4 $1 --min-rate 100 -v -oN $1_nmap $2;
}

ams(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
amass enum -d $1 -json $1.json
jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1_domainlist
}

virtualmachine(){ #Run VirtualBox in background
VBoxManage startvm $1 --type headless
}

maps(){
telnet mapscii.me;
}

myip(){
curl http://ipinfo.io/$1; echo
}

im(){ # image manager
tiv $1;
}

spf(){
spotifycli
}

rec(){
asciinema rec;
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
