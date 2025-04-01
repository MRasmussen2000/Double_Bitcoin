# Double_Bitcoin
Bitcoin SHA-256 VSLI Final Project


Golden Example

    sudo apt install libssl-dev

    g++ double_sha256.cpp -o double_sha256 -lssl -lcrypto

    ./double_sha256

Macos
    g++ Bitcoin_SHA-256.cpp -o double_sha256 \
  -I/opt/homebrew/opt/openssl/include \
  -L/opt/homebrew/opt/openssl/lib \
  -lssl -lcrypto

  