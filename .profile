dirsearch(){ runs dirsearch and takes host and extension as arguments
python3 ~/tools/dirsearch/dirsearch.py -u $1 -e $2 -t 50 -b 
}

myip(){
curl http://ipecho.net/plain; echo
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

rot4(){
 tr 'e-za-dE-ZA-D' 'a-zA-Z'
}

rot5(){
 tr 'f-za-eF-ZA-E' 'a-zA-Z'
}

rot6(){
 tr 'g-za-fG-ZA-F' 'a-zA-Z'
}

rot7(){
 tr 'h-za-gH-ZA-G' 'a-zA-Z'
}

rot8(){
 tr 'i-za-hI-ZA-H' 'a-zA-Z'
}

rot9(){
 tr '-za-iJ-ZA-I' 'a-zA-Z'
}

rot10(){
 tr 'k-za-jK-ZA-J' 'a-zA-Z'
}

rot11(){
 tr 'l-za-kL-ZA-K' 'a-zA-Z'
}

rot12(){
 tr 'm-za-lM-ZA-L' 'a-zA-Z'
}

rot13(){
 tr 'n-za-mN-ZA-M' 'a-zA-Z'
}

rot14(){
 tr 'o-za-nO-ZA-N' 'a-zA-Z'
}

rot15(){
 tr 'p-za-oP-ZA-O' 'a-zA-Z'
}

rot16(){
 tr 'q-za-pQ-ZA-P' 'a-zA-Z'
}

rot17(){
 tr 'r-za-qR-ZA-Q' 'a-zA-Z'
}

rot18(){
 tr 's-za-rS-ZA-R' 'a-zA-Z'
}

rot19(){
 tr 't-za-sT-ZA-S' 'a-zA-Z'
}

rot20(){
 tr 'u-za-tU-ZA-T' 'a-zA-Z'
}

rot21(){
 tr 'v-za-uV-ZA-U' 'a-zA-Z'
}

rot22(){
 tr 'w-za-vW-ZA-V' 'a-zA-Z'
}

rot23(){
 tr 'x-za-wX-ZA-W' 'a-zA-Z'
}

rot24(){
 tr 'y-za-xY-ZA-X' 'a-zA-Z'
}

rot25(){
 tr 'z-za-yZ-ZA-Y' 'a-zA-Z'
}
