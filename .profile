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
    python3 ~/Tools/dirsearch/dirsearch.py --random-agent -t 1000 -u $1 -b -f -r -e sh,txt,php,html,htm,zip,tar.gz,tar,json -x 400,403,404 -o=$1_dirs --format=simple;
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
    python3 ~/Tools/sqlmap/sqlmap.py -u $1 --random-agent --banner --threads 10 --time-sec 10 --retries 5 --batch --alert="./sqli2telegram.sh $1" $@
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

fuzz(){ # fuzz site.com/?q=FUZZ
    ffuf -c -ac -r -w ~/Tools/OneListForAll/onelistforallshort.txt -u $1 -fc 401,403
}

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
    extIp=$(dig +short myip.opendns.com @resolver1.opendns.com)

    printf "\e[32mWireless IP: \033[0m"
    my_ip=$(/sbin/ifconfig wlan0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${my_ip:-"Not connected"}


    printf "\e[32mWired IP: \033[0m"
    my_ip=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${my_ip:-"Not connected"}

    printf "\e[32mVpn IP: \033[0m"
    my_ip=$(/sbin/ifconfig tun0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${my_ip:-"Not connected"}

    echo ""
    echo "\e[32mWAN IP: \033[0m$extIp"
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
    streamlink --twitch-disable-ads https://www.twitch.tv/$1 best -Q &
}

phone() {
    adb kill-server &>/dev/null
    adb start-server &>/dev/null
    adb disconnect &>/dev/null
    PhoneIp=192.168.1.254 # Make the phone's ip address static
    PhonePort=5555 # Phone Adb Port

    if ping -c 1 ${PhoneIp} &>/dev/null; then
        if nc -z -v -w5 ${PhoneIp} ${PhonePort} &>/dev/null; then
            adb connect ${PhoneIp}:${PhonePort} &>/dev/null
            echo "\nWireless Connect Devices!\n"
            scrcpy --always-on-top &>/dev/null &
        else
            echo "Rejected connection on phone"
        fi
    elif adb usb &>/dev/null; then
        echo "\nUSB Connect Devices!\n"
        sleep 3
        scrcpy --always-on-top &>/dev/null &
    else
        echo "\nNot Devices!"
    fi
}


rsa(){
    echo "N: "; read N
    echo "E: "; read E
    echo "C: "; read C
    
    python3 ~/Tools/RsaCtfTool/RsaCtfTool.py -n $N -e $E --uncipher $C
}

base(){ # base "aEx0QWt5ZG4="
    echo -e "$@" | base32 -d
    echo "\e[32m  └────Base32 \033[0m"
    echo -e "$@" | base58 -d
    echo "\e[32m  └────Base58 \033[0m"
    echo -e "$@" | base64 -d
    echo "\e[32m  └────Base64 \033[0m"
}

rot() { # rot "gKsZjxcm"
    echo "$@" | tr 'd-za-cD-ZA-C' 'a-zA-Z'
    echo -e "\e[32m  └────Rot3 \033[0m"

    echo "$@" | tr 'e-za-dE-ZA-D' 'a-zA-Z'
    echo -e "\e[32m  └────Rot4 \033[0m"

    echo "$@" | tr 'f-za-eF-ZA-E' 'a-zA-Z'
    echo -e "\e[32m  └────Rot5 \033[0m"

    echo "$@" | tr 'g-za-fG-ZA-F' 'a-zA-Z'
    echo -e "\e[32m  └────Rot6 \033[0m"

    echo "$@" | tr 'h-za-gH-ZA-G' 'a-zA-Z'
    echo -e "\e[32m  └────Rot7 \033[0m"

    echo "$@" | tr 'i-za-hI-ZA-H' 'a-zA-Z'
    echo -e "\e[32m  └────Rot8 \033[0m"

    echo "$@" | tr 'j-za-iJ-ZA-I' 'a-zA-Z'
    echo -e "\e[32m  └────Rot9 \033[0m"

    echo "$@" | tr 'k-za-jK-ZA-J' 'a-zA-Z'
    echo -e "\e[32m  └────Rot10 \033[0m"

    echo "$@" | tr 'l-za-kL-ZA-K' 'a-zA-Z'
    echo -e "\e[32m  └────Rot11 \033[0m"

    echo "$@" | tr 'm-za-lM-ZA-L' 'a-zA-Z'
    echo -e "\e[32m  └────Rot12 \033[0m"

    echo "$@" | tr 'n-za-mN-ZA-M' 'a-zA-Z'
    echo -e "\e[32m  └────Rot13 \033[0m"

    echo "$@" | tr 'o-za-nO-ZA-N' 'a-zA-Z'
    echo -e "\e[32m  └────Rot14 \033[0m"

    echo "$@" | tr 'p-za-oP-ZA-O' 'a-zA-Z'
    echo -e "\e[32m  └────Rot15 \033[0m"

    echo "$@" | tr 'q-za-pQ-ZA-P' 'a-zA-Z'
    echo -e "\e[32m  └────Rot16 \033[0m"

    echo "$@" | tr 'r-za-qR-ZA-Q' 'a-zA-Z'
    echo -e "\e[32m  └────Rot17 \033[0m"

    echo "$@" | tr 's-za-rS-ZA-R' 'a-zA-Z'
    echo -e "\e[32m  └────Rot18 \033[0m"

    echo "$@" | tr 't-za-sT-ZA-S' 'a-zA-Z'
    echo -e "\e[32m  └────Rot19 \033[0m"

    echo "$@" | tr 'u-za-tU-ZA-T' 'a-zA-Z'
    echo -e "\e[32m  └────Rot20 \033[0m"

    echo "$@" | tr 'v-za-uV-ZA-U' 'a-zA-Z'
    echo -e "\e[32m  └────Rot21 \033[0m"

    echo "$@" | tr 'w-za-vW-ZA-V' 'a-zA-Z'
    echo -e "\e[32m  └────Rot22 \033[0m"

    echo "$@" | tr 'x-za-wX-ZA-W' 'a-zA-Z'
    echo -e "\e[32m  └────Rot23 \033[0m"

    echo "$@" | tr 'y-za-xY-ZA-X' 'a-zA-Z'
    echo -e "\e[32m  └────Rot24 \033[0m"

    echo -e "$@" | tr 'z-za-yZ-ZA-Y' 'a-zA-Z'
    echo -e "\e[32m  └────Rot25 \033[0m"

    echo "$@" | tr '\!-~' 'P-~\!-O'
    echo -e "\e[32m  └────Rot47 \033[0m"
}

hex(){ # hex "68 4c 74 41 6b 79 64 6e"
    if [[ $1 == "-e" ]]; then
        echo $2 | xxd -ps | grep .
    elif [[ $@ == "" ]]; then
        echo "Enter a value!\nExample: hex '68 4c 74 41 6b 79 64 6e'"
    else
        echo "$@" | xxd -r -p | grep .
    fi
}

urlencode() { # urlencode "hello world"
    local _length="${#1}"
    for (( _offset = 0 ; _offset < _length ; _offset++ )); do
        _print_offset="${1:_offset:1}"
        case "${_print_offset}" in
            [a-zA-Z0-9.~_-]) printf "${_print_offset}" ;;
            ' ') printf + ;;
            *) printf '%%%X' "'${_print_offset}" ;;
        esac
    done
}

urldecode() { # urldecode "hello+%26+world"
   echo "$@" | sed 's@+@ @g;s@%@\\x@g' | xargs -0 printf "%b"
}

caesar() { # caesar "iMuBlzeo"
    leg=$@

    function decaesar() {
        local value
        local cipher
        value=({a..z})
        cipher=()
        cipher+=("${value[@]:(-(26 - $2))}")
        cipher+=("${value[@]:0:$(($2 + 1))}")
        echo "$1" | tr '[:upper:]' '[:lower:]' | tr "${value[*]}" "${cipher[*]}"
    }

    for i in {1..26}; do
        printf "\e[32m$(decaesar "$@" $i) \033[0m \n\033[0;35m"
        seq -s- ${#leg} | tr -d '[:digit:]'
    done

}

morse() {
    echo "$@" | sed -e 's/\.-/A/g' -e 's/-\.\.\./B/g' -e 's/-A\./C/g' -e 's/-\.\./D/g' -e 's/\./E/g' \
        -e 's/EAE/F/g' -e 's/--E/G/g' -e 's/EEEE/H/g' -e 's/EE/I/g' -e 's/A--/J/g' -e 's/-A/K/g' -e 's/AI/L/g' \
        -e 's/--/M/g' -e 's/-E/N/g' -e 's/M-/O/g' -e 's/AN/P/g' -e 's/-K/Q/g' -e 's/AE/R/g' -e 's/IE/S/g' \
        -e 's/-/T/g' -e 's/EA/U/g' -e 's/IA/V/g' -e 's/AT/W/g' -e 's/NA/X/g' -e 's/KT/Y/g' -e 's/TD/Z/g' \
        -e 's/JT/1/g' -e 's/EJ/2/g' -e 's/VT/3/g' -e 's/SA/4/g' -e 's/HE/5/g' -e 's/BE/6/g' -e 's/TB/7/g' \
        -e 's/MD/8/g' -e 's/MG/9/g' -e 's/MO/0/g' -e 's/AAA/\./g' -e 's/GW/,/g' -e 's/UD/?/g' -e 's/KW/!/g' \
        -e 's/MB/:/g' -e 's/AF/"/g' -e "s/WG/'/g" -e 's/AR/+/g' -e 's/BA/-/g' -e 's/DA/=/g' -e 's/KN/(/g' \
        -e 's/KK/)/g' -e 's/LE/\&/g' -e 's/TF/\//g' -e 's/AC/@/g'
}


csvtosql() {
    fname="$1"
    sed 's/\s*,*\s*$//g' "$fname" >tmp.csv
    op=$(echo "$fname" | cut -d"." -f 1)
    opfile="$op.sql"
    op="\`$op\`"
    columns=$(head --lines=1 tmp.csv | sed 's/,/`,`/g' | tr -d "\r\n")
    columns="\`$columns\`"
    tail --lines=+2 tmp.csv | while read l; do
        values=$(echo $l | sed 's/,/\",\"/g' | tr -d "\r\n")
        values="\"$values\""
        echo "INSERT INTO $op($columns) VALUES ($values);"
    done >"$opfile"
    rm tmp.csv
}

web(){
    sudo systemctl $1 vsftpd.service mysqld.service apache2.service
}

www(){
    python -m SimpleHTTPServer 80
}

gitall() {
    git add .
    if [ "$1" != "" ] # or better, if [ -n "$1" ]
    then
        git commit -m "$1"
    else
        git commit -m update
    fi
    git push
}
