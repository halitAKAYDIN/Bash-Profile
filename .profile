fastrecon(){ # fastrecon example.com
    mkdir ~/Recon/$1; cd ~/Recon/$1; mkdir screenshots;
    ~/Tools/subfinder -t 100 -d $1 -silent -o $1_domains -timeout 10;
    ~/Tools/naabu -iL $1_domains -silent -o $1_ports;
    cat $1_ports | ~/Tools/httprobe > $1_schemes;
    ~/Tools/nuclei -rl 250 -c 50 -t ~/nuclei-templates/subdomain-takeover/ -o $1_takeovers -l $1_schemes;
    ~/Tools/nuclei -rl 250 -c 50 -t ~/nuclei-templates/basic-detections/ -o $1_basic -l $1_schemes;
    ~/Tools/nuclei -rl 250 -c 50 -t ~/nuclei-templates/cves/ -o $1_cves -l $1_schemes;
    ~/Tools/nuclei -rl 250 -c 50 -t ~/nuclei-templates/dns/ -o $1_dbs -l $1_schemes;
    ~/Tools/nuclei -rl 250 -c 50 -t ~/nuclei-templates/files/ -o $1_files -l $1_schemes;
    ~/Tools/nuclei -rl 250 -c 50 -t ~/nuclei-templates/panels/ -o $1_panels -l $1_schemes;
    ~/Tools/nuclei -rl 250 -c 50 -t ~/nuclei-templates/technologies/ -o $1_technologies -l $1_schemes;
    ~/Tools/nuclei -rl 250 -c 50 -t ~/nuclei-templates/tokens/ -o $1_token -l $1_schemes;
    ~/Tools/nuclei -rl 250 -c 50 -t ~/nuclei-templates/vulnerabilities/ -o $1_vuln -l $1_schemes;
    ~/Tools/dnsprobe -t 500 -l $1_domains -o $1_ips ;
    ~/Tools/dnsprobe -t 500 -l $1_domains -r CNAME -o $1_cnames -silent;
    cat $1_schemes | ~/Tools/aquatone -out $1_takeover_screen;
    cat $1_domains | ~/Tools/aquatone -out $1_domains_screen;
}

takeover() { # takeover example.com
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

drs(){ # drs example.com
    mkdir ~/Recon/$1; cd ~/Recon/$1;
    python3 ~/Tools/dirsearch/dirsearch.py --random-agent -t 100 -u $1 -b -f -r -e sh,txt,php,html,htm,zip,tar.gz,tar,json -x 400,403,404 -o=$1_dirs --format=simple;
}

openurl(){ # openurl url.txt
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

sqli(){ # sqli example.com
    python3 ~/Tools/sqlmap/sqlmap.py -u $1 --headers="X-Pentester:hLtAkydn" --random-agent --level 5 --risk 3 --banner --threads 10 --time-sec 10 --retries 5 --batch --alert="./sqli2telegram.sh $1" $@
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

xss(){ # xss example.com
    python3 ~/Tools/XSStrike/xsstrike.py -t 10 -u $@
    # --seeds ~/example.com.txt -e base64 -f ~/xss.tx
}

param(){ # param example.com
    mkdir ~/Recon/$1;
    python3 ~/Tools/ParamSpider/paramspider.py --domain $1 --level high --exclude woff,css,js,png,svg,php,jpg --output ~/Recon/$1.txt
    # --subs False
}

fuzz(){ # fuzz example.com/?q=FUZZ
    ffuf -c -ac -r -w ~/Tools/OneListForAll/onelistforallshort.txt -u $1 -fc 401,403 

ams(){ # amas example.com
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

im(){ # im pic.jpg
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

twitch(){ # twitch hLtAkydn
    streamlink --twitch-disable-ads https://www.twitch.tv/$1 best
}

phone(){
    scrcpy;
}

rsa(){
    echo "N: "; read N
    echo "E: "; read E
    echo "C: "; read C
    
    python3 ~/Tools/RsaCtfTool/RsaCtfTool.py -n $N -e $E --uncipher $C
}

base(){ # base "aEx0QWt5ZG4="
    echo "$@" | base32 -d; echo "└────Base32"
    echo "$@" | base58 -d; echo "└────Base58"
    echo "$@" | base64 -d; echo "└────Base64"
}

rot(){ # rot "gKsZjxcm"
    echo "$@" | tr 'd-za-cD-ZA-C' 'a-zA-Z'; echo "└────Rot3"
    echo "$@" | tr 'e-za-dE-ZA-D' 'a-zA-Z'; echo "└────Rot4"
    echo "$@" | tr 'f-za-eF-ZA-E' 'a-zA-Z'; echo "└────Rot5"
    echo "$@" | tr 'g-za-fG-ZA-F' 'a-zA-Z'; echo "└────Rot6"
    echo "$@" | tr 'h-za-gH-ZA-G' 'a-zA-Z'; echo "└────Rot7"
    echo "$@" | tr 'i-za-hI-ZA-H' 'a-zA-Z'; echo "└────Rot8"
    echo "$@" | tr 'j-za-iJ-ZA-I' 'a-zA-Z'; echo "└────Rot9"
    echo "$@" | tr 'k-za-jK-ZA-J' 'a-zA-Z'; echo "└────Rot10"
    echo "$@" | tr 'l-za-kL-ZA-K' 'a-zA-Z'; echo "└────Rot11"
    echo "$@" | tr 'm-za-lM-ZA-L' 'a-zA-Z'; echo "└────Rot12"
    echo "$@" | tr 'n-za-mN-ZA-M' 'a-zA-Z'; echo "└────Rot13"
    echo "$@" | tr 'o-za-nO-ZA-N' 'a-zA-Z'; echo "└────Rot14"
    echo "$@" | tr 'p-za-oP-ZA-O' 'a-zA-Z'; echo "└────Rot15"
    echo "$@" | tr 'q-za-pQ-ZA-P' 'a-zA-Z'; echo "└────Rot16"
    echo "$@" | tr 'r-za-qR-ZA-Q' 'a-zA-Z'; echo "└────Rot17"
    echo "$@" | tr 's-za-rS-ZA-R' 'a-zA-Z'; echo "└────Rot18"
    echo "$@" | tr 't-za-sT-ZA-S' 'a-zA-Z'; echo "└────Rot19"
    echo "$@" | tr 'u-za-tU-ZA-T' 'a-zA-Z'; echo "└────Rot20"
    echo "$@" | tr 'v-za-uV-ZA-U' 'a-zA-Z'; echo "└────Rot21"
    echo "$@" | tr 'w-za-vW-ZA-V' 'a-zA-Z'; echo "└────Rot22"
    echo "$@" | tr 'x-za-wX-ZA-W' 'a-zA-Z'; echo "└────Rot23"
    echo "$@" | tr 'y-za-xY-ZA-X' 'a-zA-Z'; echo "└────Rot24"
    echo "$@" | tr 'z-za-yZ-ZA-Y' 'a-zA-Z'; echo "└────Rot25"
    echo "$@" | tr '\!-~' 'P-~\!-O'; echo "└────Rot47"
}


caesar(){ # caesar "iMuBlzeo"
    decaesar(){
        local value
        local cipher
        value=({a..z})
        cipher=()
        cipher+=("${value[@]:(-(26-$2))}")
        cipher+=("${value[@]:0:$(($2+1))}")
        echo "$1" | tr '[:upper:]' '[:lower:]' | tr "${value[*]}" "${cipher[*]}"
    }
    
    for i in {1..26};do
        printf "$(decaesar "$@" $i)\n";
    done
}
