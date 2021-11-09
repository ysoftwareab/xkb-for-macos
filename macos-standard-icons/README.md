```
curl https://raw.githubusercontent.com/phible/scripts/master/apple-kbd-dat-icon-extract.py -O
python apple-kbd-dat-icon-extract.py -o ./
for f in *.icns; do sips -s format png ${f} --out ${f/.icns/.png}; done
```
