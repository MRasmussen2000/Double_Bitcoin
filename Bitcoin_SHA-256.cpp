#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <openssl/sha.h>

// Convert a byte array to a hex string
std::string to_hex(const unsigned char* hash, size_t len) {
    std::stringstream ss;
    for (size_t i = 0; i < len; ++i)
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)hash[i];
    return ss.str();
}

// Perform double SHA-256 hash
std::string double_sha256(const std::string& input) {
    unsigned char first_hash[SHA256_DIGEST_LENGTH];
    unsigned char second_hash[SHA256_DIGEST_LENGTH];

    // First SHA-256
    SHA256(reinterpret_cast<const unsigned char*>(input.c_str()), input.size(), first_hash);

    // Second SHA-256
    SHA256(first_hash, SHA256_DIGEST_LENGTH, second_hash);

    return to_hex(second_hash, SHA256_DIGEST_LENGTH);
}

int main() {
    std::string input = "Hello, Bitcoin!";
    std::string hash = double_sha256(input);

    std::cout << "Input: " << input << std::endl;
    std::cout << "Double SHA-256 Hash: " << hash << std::endl;

    return 0;
}