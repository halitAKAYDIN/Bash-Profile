drs(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
python3 ~Tools/dirsearch/dirsearch.py -u $1 -b -f -r -e sh,txt,php,html,htm,zip,tar.gz,tar,json -x 400,403,404 -o=$1_dirs;
}

openurl(){
 while read -r line; do
     google-chrome-stable -new-tab "$line" 2>/dev/null &
     sleep 2
 done < "$1"
}

fastrecon(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
~/Tools/subfinder -d $1 -silent -o $1_domains;
~/Tools/naabu -iL $1_domains -silent -t 30 -o $1_ports;
cat $1_ports | ~/Tools/httprobe > $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/subdomain-takeover/ -o $1_takeovers -l $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/basic-detections/ -o $1_basic -l $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/cves/ -o $1_cves -l $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/dns/ -o $1_dbs -l $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/files/ -o $1_files -l $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/panels/ -o $1_panels -l $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/technologies/ -o $1_technologies -l $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/tokens/ -o $1_token -l $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/vulnerabilities/ -o $1_vuln -l $1_schemes;
~/Tools/nuclei -c 30 -t ~/nuclei-templates/workflows/ -o $1_workflows -l $1_schemes;
~/Tools/dnsprobe -l $1_domains -o $1_ips ;
~/Tools/dnsprobe -l $1_domains -r CNAME -o $1_cnames -silent;
~/Tools/cat $1_schemes | ~/Tools/aquatone -out $1_takeover_screen;
~/Tools/cat $1_domains | ~/Tools/aquatone -out $1_domains_screen;
}

nmapfast(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
nmap -A -Pn -T4 $1 --min-rate 100 -v -oN $1_nmap $2;
}

sqli(){
python3 ~/Tools/sqlmap/sqlmap.py -u $1 --headers="X-HackerOne:hLtAkydn" --random-agent --tamper between,randomcase,space2comment --level 5 --risk 3 --threads 10 --time-sec 10 --batch --alert="./sqli2telegram.sh $1" $2
}

xss(){
python3 ~/Tools/XSStrike/xsstrike.py -u $1
}

param(){
python3 ~/Tools/ParamSpider/paramspider.py --domain $1 --level high --subs False --exclude woff,css,js,png,svg,php,jpg
}

fuzz(){
ffuf -c -ac -r -w ~/Tools/OneListForAll/onelistforallshort.txt -u "$1" -fc 401,403 # example: fuzz site.com/?q=FUZZ
}

ams(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
amass enum -d $1 -json $1.json
jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1_domainlist
}

spider(){
python3 /opt/spiderfoot/sf.py -l 127.0.0.1:5001
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
fim $1;
}

fl(){ # file manager
lf;
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
