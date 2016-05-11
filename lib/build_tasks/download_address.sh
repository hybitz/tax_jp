#!/bin/sh

ZIP_FILE=ken_all.zip

if [ -e tmp/${ZIP_FILE} ]; then
  echo "tmp/${ZIP_FILE} が存在するので、再ダウンロードは行いません。"
else
  mkdir tmp
  curl -# -o tmp/${ZIP_FILE} -LO http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip
fi

pushd tmp
  rm -f KEN_ALL.CSV
  unzip ${ZIP_FILE}
  iconv -f SJIS -t UTF8 KEN_ALL.CSV > ../data/住所/addresses.csv
popd
