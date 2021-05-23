takeover() {
    mkdir ~/Recon/$1; cd ~/Recon/$1; mkdir screenshots;
    subfinder -t 100 -d $1 -o $1_domains;
    naabu -iL $1_domains -o $1_ports;
    cat $1_ports | httprobe -c 30 > $1_schemes;
    nuclei -rl 250 -c 50 -t ~/nuclei-templates/subdomain-takeover/ -o $1_takeovers -l $1_schemes;

    dnsprobe -t 500 -l $1_domains -o $1_ips;
    dnsprobe -t 500 -l $1_domains -r CNAME -o $1_cnames;

	gowitness file -f $1_schemes --threads 100
	gowitness report serve;
}

drs(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
python3 ~/Tools/dirsearch/dirsearch.py --random-agent -t 100 -u $1 -b -f -r -e sh,txt,php,html,htm,zip,tar.gz,tar,json -x 400,403,404 -o=$1_dirs --format=simple;
}

openurl(){
 while read -r line; do
     google-chrome-stable -new-tab "$line" 2>/dev/null &
     sleep 2
 done < "$1"
}

s3ls(){
aws s3 ls s3://$1
}

s3cp(){
aws s3 cp $2 s3://$1 
}

crtsh(){
curl -s https://crt.sh/?Identity=%.$1 | grep ">*.$1" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$1" | sort -u | awk 'NF'
}

nmapfast(){
mkdir ~/Recon/$1; cd ~/Recon/$1;
nmap -A -Pn -T4 $1 --min-rate 100 -v -oN $1_nmap $2;
}

sqli(){
python3 ~/Tools/sqlmap/sqlmap.py -u $1 --headers="X-HackerOne:" --random-agent --level 5 --risk 3 --banner --threads 10 --time-sec 10 --retries 5 --batch --alert="./sqli2telegram.sh $1" $@
# --level 5 --risk 3
# --drop-set-cookie
# --csrf-token
# --tor --tor-type=SOCKS5 --tor-port=9050
# --forms

# General scripts
# --tamper=apostrophemask,apostrophenullencode,base64encode,between,chardoubleencode,charencode,charunicodeencode,equaltolike,greatest,ifnull2ifisnull,multiplespaces,percentage,randomcase,space2comment,space2plus,space2randomblank,unionalltounion,unmagicquotes
# Microsoft access
# --tamper=between,bluecoat,charencode,charunicodeencode,concat2concatws,equaltolike,greatest,halfversionedmorekeywords,ifnull2ifisnull,modsecurityversioned,modsecurityzeroversioned,multiplespaces,percentage,randomcase,space2comment,space2hash,space2morehash,space2mysqldash,space2plus,space2randomblank,unionalltounion,unmagicquotes,versionedkeywords,versionedmorekeywords
# Microsoft SQL Server
# --tamper=between,charencode,charunicodeencode,equaltolike,greatest,multiplespaces,percentage,randomcase,sp_password,space2comment,space2dash,space2mssqlblank,space2mysqldash,space2plus,space2randomblank,unionalltounion,unmagicquotes
# MySQL
# --tamper=between,bluecoat,charencode,charunicodeencode,concat2concatws,equaltolike,greatest,halfversionedmorekeywords,ifnull2ifisnull,modsecurityversioned,multiplespaces,percentage,randomcase,space2comment,space2hash,space2morehash,space2mysqldash,space2plus,space2randomblank,unionalltounion,unmagicquotes,versionedkeywords,versionedmorekeywords,xforwardedfor
# Oracle
# --tamper=between,charencode,equaltolike,greatest,multiplespaces,randomcase,space2comment,space2plus,space2randomblank,unionalltounion,unmagicquotes,xforwardedfor
# PostgreSQL
# --tamper=between,charencode,charunicodeencode,equaltolike,greatest,multiplespaces,nonrecursivereplacement,percentage,randomcase,securesphere,space2comment,space2plus,space2randomblank,xforwardedfor
# SAP MaxDB
# --tamper=ifnull2ifisnull,nonrecursivereplacement,randomcase,securesphere,space2comment,space2plus,unionalltounion,unmagicquotes,xforwardedfor
# SQLite
# --tamper=ifnull2ifisnull,multiplespaces,nonrecursivereplacement,randomcase,securesphere,space2comment,space2dash,space2plus,unionalltounion,unmagicquotes,xforwardedfor
}

xss(){
python3 ~/Tools/XSStrike/xsstrike.py -t 10 -u $@
# --seeds ~/example.com.txt -e base64 -f ~/xss.tx
}

param(){
mkdir ~/Recon/$1;
python3 ~/Tools/ParamSpider/paramspider.py --domain $1 --level high --exclude woff,css,js,png,svg,php,jpg --output ~/Recon/$1.txt
# --subs False
}

fuzz(){
ffuf -c -ac -r -w ~/Tools/OneListForAll/onelistforallshort.txt -u $1 -fc 401,403 # example: fuzz site.com/?q=FUZZ
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

caesar(){
 tr '[X-ZA-W]' '[A-Z]'
}
