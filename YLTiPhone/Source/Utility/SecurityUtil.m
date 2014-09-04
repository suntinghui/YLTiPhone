//
//  SecurityUtil.m
//  BLECard
//
//  Created by  STH on 3/15/14.
//  Copyright (c) 2014 Jason. All rights reserved.
//

#import "SecurityUtil.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonCrypto.h>
#import "ConvertUtil.h"
#include <openssl/evp.h>
#include <string.h>

@implementation SecurityUtil

+ (NSString *) md5Crypto:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *) encryptUseDES:(NSData *)textData key:(NSData *)keyData
{
    NSString *ciphertext = nil;
    
    NSUInteger dataLength = [textData length];
    
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [keyData bytes], kCCKeySizeDES,
                                          nil,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [ConvertUtil data2HexString:data];
    }else{
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}

+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *cleartext = nil;
    
    NSData *textData = [ConvertUtil parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    
    NSData *keyData = [ConvertUtil parseHexToByteArray:key];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [keyData bytes], kCCKeySizeDES,
                                          nil,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
//        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [ConvertUtil data2HexString:data];
    }else{
        NSLog(@"DES解密失败");
    }
    return cleartext;
}

// 一定要注意，密钥必须是24字节，如果是16字节的话，可以将前8字节再放在最后，组成24字节。
+ (NSString *) encryptUseTripleDES:(NSString *)clearText key:(NSString *)key
{
    NSString *ciphertext = nil;
    
    NSData *textData = [ConvertUtil parseHexToByteArray:clearText];
    NSUInteger dataLength = [textData length];
    
    NSData *keyData = [ConvertUtil parseHexToByteArray:key];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                          kCCOptionECBMode,
                                          [keyData bytes], kCCKeySize3DES,
                                          nil,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
//        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        ciphertext = [ConvertUtil parseByteArray2HexString:bb];
    }else{
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}

+ (NSString *) decryptUseTripleDES:(NSString *)plainText key:(NSString *)key
{
    NSString *cleartext = nil;
    
    NSData *textData = [ConvertUtil parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    
    NSData *keyData = [ConvertUtil parseHexToByteArray:key];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithm3DES,
                                          kCCOptionECBMode,
                                          [keyData bytes], kCCKeySize3DES,
                                          nil,
                                          [textData bytes]	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
//        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [ConvertUtil data2HexString:data];
    }else{
        NSLog(@"DES解密失败");
    }
    return cleartext;
}

+ (NSString *) encryptUseXOR:(NSString *) data withKey:(NSString *)key
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:data];
    while (str.length % 16 != 0) {
        [str appendString:@"00"];
    }
    
    NSData *dataData = [ConvertUtil parseHexToByteArray:str];
    NSData *keyData = [ConvertUtil parseHexToByteArray:key];
    
    NSData *result = [SecurityUtil encryptXOR:dataData withKey:keyData];
    
    return [ConvertUtil data2HexString:result];
}

+ (NSData *) encryptXOR:(NSData *) data withKey:(NSData *) key
{
    //TODO: #warning This needs to be thoroughly audited, I'm not sure I follow this correctly
	// From SO post http://stackoverflow.com/questions/11724527/xor-file-encryption-in-ios
	NSMutableData *result = data.mutableCopy;
    
    // Get pointer to data to obfuscate
    char *dataPtr = (char *)result.mutableBytes;
    
    // Get pointer to key data
    char *keyData = (char *)key.bytes;
    
    // Points to each char in sequence in the key
    char *keyPtr = keyData;
    int keyIndex = 0;
    
    // For each character in data, xor with current value in key
    for (int x = 0; x < data.length; x++)
    {
        // Replace current character in data with
        // current character xor'd with current key value.
        // Bump each pointer to the next character
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        // If at end of key data, reset count and
        // set key pointer back to start of key value
        if (++keyIndex == key.length)
		{
            keyIndex = 0;
			keyPtr = keyData;
		}
	}
    
    return result;
}

// 根据源数组 按每8个字节一组进行遍历异或 不满8字节补零 得到异或后的最后8个字节数组
+ (NSString *) encryptUseXOR8:(NSString *) data
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:data];
    while (str.length % 16 != 0) {
        [str appendString:@"00"];
    }
    
    
    if (str.length == 16) {
        return [SecurityUtil encryptUseXOR:str withKey:str];
        
    } else if (str.length == 32){
        NSString *temp = [SecurityUtil encryptUseXOR:[str substringToIndex:16] withKey:[str substringFromIndex:16]];
        return temp;
        
    } else {
        NSString *temp = [SecurityUtil encryptUseXOR:[str substringToIndex:16] withKey:[str substringFromIndex:16]];
        
        unsigned long count = str.length/16-1;
        for (int i=2; i<count+1; i++) {
            temp = [SecurityUtil encryptUseXOR:temp withKey:[str substringWithRange:NSMakeRange(16*i, 16)]];
        }
        
        return temp;
    }
    
}

// 根据源数组 按每16个字节一组进行遍历异或 不满16字节补零 得到异或后的最后16个字节数组
+ (NSString *) encryptUseXOR16:(NSString *) data
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:data];
    while (str.length % 32 != 0) {
        [str appendString:@"00"];
    }
    
    
    if (str.length == 32) {
        return [SecurityUtil encryptUseXOR:str withKey:str];
        
    } else if (str.length == 64){
        NSString *temp = [SecurityUtil encryptUseXOR:[str substringToIndex:32] withKey:[str substringFromIndex:32]];
        return temp;
        
    } else {
        NSString *temp = [SecurityUtil encryptUseXOR:[str substringToIndex:32] withKey:[str substringFromIndex:32]];
        
        unsigned long count = str.length/32-1;
        for (int i=2; i<count+1; i++) {
            temp = [SecurityUtil encryptUseXOR:temp withKey:[str substringWithRange:NSMakeRange(32*i, 32)]];
        }
        
        return temp;
    }
    
}

+ (NSData *) encryptXORAndMac:(NSString *) data withKey:(NSString *) macKey
{
    // 将数据进行8字节异或运算
    NSString *xorStr = [SecurityUtil encryptUseXOR8:data];
    
    NSData *xorData = [xorStr dataUsingEncoding:NSASCIIStringEncoding];
//    NSData *xorData = [xorStr dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    
    // 取前8个字节用MAK加密(进行DES)
    NSData *macData = [ConvertUtil parseHexToByteArray:macKey];
    NSString *tempStr1 = [SecurityUtil encryptUseDES:[xorData subdataWithRange:NSMakeRange(0, 8)] key:macData];
    NSData *tempData1 = [ConvertUtil parseHexToByteArray:tempStr1];
    
    // 前8个字节进行DES的结果值与后8个字节异或运算
    NSData *tempData2 = [SecurityUtil encryptXOR:tempData1 withKey:[xorData subdataWithRange:NSMakeRange(8, 8)]];
    
    // 用异或的结果,再一次用MAK加密（单倍长密钥算法运算）（进行DES运算）
    NSString *tmp = [SecurityUtil encryptUseDES:tempData2 key:macData];
    
    NSData *tmpData = [[tmp substringToIndex:8] dataUsingEncoding:NSASCIIStringEncoding];
//    NSData *tmpData = [[tmp substringToIndex:8] dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSLog(@"***:%@", tmpData);
    return tmpData;
}

#define BETWEEN(VAL, vmin, vmax) ((VAL) >= (vmin) && (VAL) <= (vmax))
#define ISHEXCHAR(VAL) (BETWEEN(VAL, '0', '9') || BETWEEN(VAL, 'A', 'F') || BETWEEN(VAL, 'a', 'f'))

char BYTE2HEX(uint8 int_val)
{
    if (BETWEEN(int_val, 0, 9))
    {
        return int_val + 0x30;
    }
    
    if (BETWEEN(int_val, 0xA, 0xF))
    {
        return (int_val - 0xA) + 'A';
    }
    
    return '0';
}
uint BIN2HEX(uint8 * p_binstr, uint bin_len, uint8 * p_hexstr)
{
    uint32 index   = 0;
    uint32 hex_len = bin_len * 2;
    
    for (index = 0; index < bin_len; index++)
    {
        p_hexstr[index * 2] = BYTE2HEX((p_binstr[index] >> 4) & 0x0F);
        p_hexstr[(index * 2) + 1] = BYTE2HEX(p_binstr[index] & 0x0F);
    }
	p_hexstr[hex_len]=0;
    
    return hex_len;
}

char *hex2bin(char *hex,unsigned int hex_len)
{
	int pos = 0;
	int offset = 0;
	long long_char;
	char *endptr;
	char temp_hex[3] = "\0\0";
	char *bin;
	bin = malloc(hex_len/2 + 1);
	memset(bin,0,hex_len/2 + 1);
	while(pos <= hex_len)
	{
		memcpy(temp_hex,hex+pos,2);
		long_char = strtol(temp_hex, &endptr, 16);
		if(long_char)
		{
			offset += sprintf(bin + offset, "%c", (unsigned char)long_char);
		}
		else
		{
			offset++;
		}
		pos += 2;
	}
	return bin;
}

+ (NSString *) encryptUseAES:(NSString *) plainText
{
    const EVP_CIPHER *cipher;
    unsigned char key[22]="gn31^&wjngqo2#%$%Ysadv";
	unsigned char iv[17]="0102030405060708";
    
    const char *in = [plainText cStringUsingEncoding:NSUTF8StringEncoding];
    int len,inl=strlen((char *)in);
	unsigned char *out=malloc(inl+128);
	if (out==NULL)
		return NULL;
	int outl=0;
	unsigned char *hexstr=malloc(2*inl+256);
	if (hexstr==NULL){
		free(out);
		return NULL;
	}
	
    EVP_CIPHER_CTX             ctx;
    EVP_CIPHER_CTX_init(&ctx);
	
    cipher  = EVP_aes_128_cbc();
    EVP_EncryptInit_ex(&ctx, cipher, NULL, key, iv);
	
    len=0;
    
    EVP_EncryptUpdate(&ctx,out+len,&outl,in,inl);
    len+=outl;
    
    EVP_EncryptFinal_ex(&ctx,out+len,&outl);
    len+=outl;
    
    EVP_CIPHER_CTX_cleanup(&ctx);
	
	BIN2HEX(out, len, hexstr);
    
	NSString *result = [[NSString alloc] initWithCString:(const char*)hexstr encoding:NSUTF8StringEncoding];
	free(out);
	free(hexstr);
    return result;
}

+ (NSString *) decryptUseAES:(NSString *) clearText
{
    const EVP_CIPHER *cipher;
    unsigned char key[22]="gn31^&wjngqo2#%$%Ysadv";
	unsigned char iv[17]="0102030405060708";
	const char *hex = [clearText UTF8String];
	
    unsigned char* out = hex2bin(hex, strlen((char *)hex));
    int len,outl= strlen(hex)/2;
    int del = 0;
    unsigned char *de = malloc(outl+128);
	if(de == NULL)
		return NULL;
	
    EVP_CIPHER_CTX             ctx;
   	
    cipher  = EVP_aes_128_cbc();
    
    EVP_CIPHER_CTX_init(&ctx);
	
    EVP_DecryptInit_ex(&ctx, cipher, NULL, key, iv);
	
    
	len=0;
    EVP_DecryptUpdate(&ctx,de, &del, out,outl);
    len+=del;
    
    EVP_DecryptFinal_ex(&ctx,de+len,&del);
    len+=del;
    de[len]=0;
    EVP_CIPHER_CTX_cleanup(&ctx);
    
//    NSString *result = [[NSString alloc] initWithUTF8String:de]; //TODO
    NSString *result = [[NSString alloc] initWithCString:de encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
	return result;
}

@end
