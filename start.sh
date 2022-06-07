docker build -t node-sass-loongarch64 .
docker run --rm -v "$(pwd)"/dist:/dist node-sass-loongarch64
ls -al "$(pwd)"/dist
