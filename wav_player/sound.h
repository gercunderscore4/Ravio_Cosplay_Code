#ifndef __SOUND_H__
#define __SOUND_H__

#include <avr/pgmspace.h>

// Audio encoded as unsigned 8-bit, 8kHz sampling rate
const uint8_t quack_wav[] PROGMEM = {
    0x7d, 0x7c, 0x7e, 0x7e, 0x7d, 0x7b, 0x7b, 0x7c, 0x7c, 0x7e, 0x7f, 0x7f,
    0x81, 0x83, 0x84, 0x86, 0x88, 0x8a, 0x8b, 0x8c, 0x88, 0x7f, 0x76, 0x6f,
    0x6c, 0x6d, 0x71, 0x75, 0x78, 0x78, 0x75, 0x6b, 0x64, 0x62, 0x61, 0x67,
    0x6f, 0x76, 0x7d, 0x82, 0x85, 0x82, 0x7f, 0x7b, 0x79, 0x79, 0x7f, 0x88,
    0x8e, 0x93, 0x94, 0x92, 0x8d, 0x86, 0x81, 0x80, 0x83, 0x89, 0x91, 0x9a,
    0xa3, 0xa9, 0xab, 0xa5, 0x91, 0x70, 0x59, 0x58, 0x67, 0x80, 0x96, 0xa3,
    0xa5, 0x98, 0x7a, 0x5c, 0x50, 0x55, 0x6a, 0x80, 0x8e, 0x96, 0x94, 0x89,
    0x77, 0x69, 0x62, 0x67, 0x73, 0x79, 0x7a, 0x74, 0x6b, 0x64, 0x63, 0x68,
    0x6d, 0x70, 0x6f, 0x6b, 0x67, 0x64, 0x66, 0x6d, 0x78, 0x84, 0x8d, 0x94,
    0x97, 0x94, 0x92, 0x8e, 0x92, 0x9e, 0xae, 0xc4, 0xd6, 0xdd, 0xc7, 0x84,
    0x45, 0x37, 0x58, 0x95, 0xbd, 0xc1, 0xb2, 0x8c, 0x53, 0x28, 0x24, 0x49,
    0x88, 0xaf, 0xb1, 0x9f, 0x88, 0x79, 0x71, 0x78, 0x8b, 0xa1, 0xa2, 0x91,
    0x7c, 0x71, 0x7a, 0x85, 0x8c, 0x88, 0x77, 0x5c, 0x3f, 0x31, 0x38, 0x53,
    0x6a, 0x73, 0x6b, 0x59, 0x4f, 0x50, 0x5f, 0x76, 0x87, 0x91, 0x93, 0x8f,
    0x8d, 0x91, 0x9d, 0xb2, 0xcf, 0xe8, 0xf3, 0xd7, 0x7d, 0x25, 0x22, 0x67,
    0xbe, 0xe2, 0xbd, 0x86, 0x58, 0x38, 0x34, 0x4e, 0x7c, 0x9f, 0x93, 0x71,
    0x68, 0x7e, 0xa0, 0xb3, 0xad, 0x96, 0x7c, 0x6e, 0x71, 0x90, 0xb1, 0xb6,
    0x9f, 0x76, 0x5a, 0x50, 0x4d, 0x55, 0x59, 0x55, 0x4c, 0x45, 0x46, 0x4e,
    0x56, 0x5a, 0x5e, 0x5d, 0x5f, 0x69, 0x7a, 0x91, 0xa2, 0xaa, 0xb1, 0xba,
    0xc6, 0xe5, 0xf2, 0xb3, 0x4f, 0x23, 0x59, 0xad, 0xd6, 0xb6, 0x7c, 0x63,
    0x4d, 0x3e, 0x51, 0x66, 0x6d, 0x60, 0x56, 0x75, 0xa5, 0xb6, 0xa6, 0x84,
    0x6c, 0x73, 0x8a, 0xa2, 0xb3, 0xab, 0x96, 0x8c, 0x8b, 0x8b, 0x7a, 0x62,
    0x52, 0x4c, 0x4e, 0x52, 0x59, 0x58, 0x54, 0x50, 0x51, 0x5b, 0x5f, 0x6a,
    0x7c, 0x80, 0x85, 0x8f, 0xa8, 0xc8, 0xe3, 0xed, 0xe9, 0xa0, 0x24, 0x35,
    0xa0, 0xe7, 0xde, 0x82, 0x57, 0x6f, 0x83, 0x7b, 0x66, 0x3f, 0x29, 0x44,
    0x79, 0xb4, 0xb0, 0x7b, 0x67, 0x79, 0x95, 0x9e, 0x94, 0x85, 0x82, 0x8b,
    0xa5, 0xba, 0x9d, 0x6d, 0x59, 0x69, 0x76, 0x65, 0x4e, 0x49, 0x53, 0x5d,
    0x63, 0x57, 0x4b, 0x5d, 0x76, 0x85, 0x83, 0x7c, 0x90, 0xbb, 0xdf, 0xf2,
    0xe2, 0x7b, 0x1d, 0x56, 0xd4, 0xf7, 0xa1, 0x4b, 0x70, 0xae, 0x9e, 0x7c,
    0x43, 0x15, 0x2d, 0x69, 0xa5, 0x9e, 0x5b, 0x52, 0x89, 0xa8, 0x94, 0x70,
    0x64, 0x7d, 0x9a, 0xaa, 0xb1, 0x8a, 0x57, 0x6a, 0x99, 0x97, 0x67, 0x47,
    0x4f, 0x69, 0x6d, 0x5c, 0x59, 0x52, 0x5c, 0x7a, 0x85, 0x81, 0x82, 0xa1,
    0xd4, 0xec, 0xe4, 0xc2, 0x54, 0x23, 0x9d, 0xf6, 0xd6, 0x6f, 0x45, 0xa4,
    0xd0, 0x86, 0x44, 0x25, 0x37, 0x7d, 0x9a, 0x88, 0x5a, 0x4f, 0x92, 0xb0,
    0x84, 0x64, 0x78, 0x95, 0x9d, 0x90, 0x8d, 0x8d, 0x83, 0x91, 0x91, 0x71,
    0x51, 0x55, 0x72, 0x76, 0x65, 0x5a, 0x5f, 0x6c, 0x74, 0x79, 0x78, 0x77,
    0x97, 0xc2, 0xd7, 0xeb, 0xc2, 0x47, 0x3c, 0xbd, 0xf0, 0xab, 0x5a, 0x77,
    0xcd, 0xad, 0x5d, 0x3e, 0x41, 0x74, 0x90, 0x6e, 0x4a, 0x3f, 0x82, 0xba,
    0x82, 0x4a, 0x63, 0x92, 0xa0, 0x87, 0x70, 0x7b, 0x8a, 0x9d, 0xa5, 0x76,
    0x4b, 0x5e, 0x89, 0x77, 0x47, 0x46, 0x62, 0x7a, 0x74, 0x6b, 0x75, 0x81,
    0x99, 0xc6, 0xdd, 0xcb, 0x78, 0x19, 0x81, 0xf7, 0xac, 0x59, 0x53, 0xae,
    0xe7, 0x7d, 0x3b, 0x4b, 0x56, 0x87, 0x88, 0x4c, 0x3a, 0x68, 0xac, 0x9a,
    0x41, 0x37, 0x85, 0x9a, 0x80, 0x6e, 0x6a, 0x80, 0x8c, 0x92, 0x8a, 0x70,
    0x65, 0x71, 0x78, 0x64, 0x5a, 0x63, 0x6a, 0x75, 0x76, 0x82, 0x94, 0x9c,
    0xbc, 0xd3, 0xc6, 0x5b, 0x25, 0xaf, 0xec, 0x90, 0x50, 0x73, 0xc0, 0xcb,
    0x75, 0x3f, 0x55, 0x73, 0x9a, 0x82, 0x4d, 0x56, 0x96, 0xaf, 0x68, 0x3b,
    0x68, 0xa0, 0x89, 0x61, 0x6e, 0x8b, 0x95, 0x85, 0x80, 0x78, 0x74, 0x7d,
    0x7b, 0x67, 0x5d, 0x74, 0x76, 0x60, 0x67, 0x7e, 0x8c, 0x98, 0xae, 0xc3,
    0xcb, 0x79, 0x23, 0x86, 0xe5, 0xa9, 0x55, 0x69, 0xc2, 0xce, 0x7f, 0x47,
    0x50, 0x6c, 0x93, 0x75, 0x40, 0x5b, 0x95, 0xb7, 0x76, 0x38, 0x68, 0xa0,
    0x8f, 0x5b, 0x52, 0x7d, 0x9c, 0x8d, 0x79, 0x73, 0x75, 0x7a, 0x74, 0x66,
    0x58, 0x6a, 0x7f, 0x71, 0x68, 0x75, 0x88, 0x9e, 0xaa, 0xac, 0xb6, 0x5a,
    0x23, 0xaa, 0xdd, 0x7a, 0x42, 0x75, 0xc1, 0xb5, 0x5e, 0x44, 0x66, 0x7e,
    0x8d, 0x5e, 0x44, 0x7e, 0xa9, 0x9b, 0x67, 0x4b, 0x82, 0xa5, 0x74, 0x5f,
    0x6b, 0x8e, 0xa2, 0x8c, 0x7f, 0x7b, 0x7f, 0x7d, 0x7b, 0x79, 0x66, 0x68,
    0x82, 0x8a, 0x8a, 0x8d, 0x8b, 0xa7, 0xb8, 0xbc, 0xa0, 0x39, 0x67, 0xdd,
    0xaa, 0x5e, 0x63, 0x93, 0xc3, 0x91, 0x48, 0x5d, 0x75, 0x8c, 0x82, 0x48,
    0x61, 0xa5, 0x9d, 0x6a, 0x54, 0x6f, 0x96, 0x7d, 0x59, 0x66, 0x80, 0x8f,
    0x87, 0x78, 0x72, 0x7d, 0x80, 0x72, 0x73, 0x70, 0x6f, 0x7f, 0x85, 0x88,
    0x96, 0xa3, 0xb2, 0xb4, 0xb1, 0x78, 0x45, 0xa5, 0xcd, 0x74, 0x5f, 0x87,
    0xa6, 0xa2, 0x70, 0x5a, 0x6a, 0x75, 0x81, 0x6c, 0x52, 0x72, 0xa2, 0x90,
    0x5a, 0x5a, 0x82, 0x92, 0x66, 0x56, 0x72, 0x82, 0x7d, 0x76, 0x79, 0x73,
    0x73, 0x6f, 0x6f, 0x71, 0x67, 0x6d, 0x72, 0x75, 0x88, 0x8e, 0x9a, 0xaf,
    0xb3, 0xba, 0x63, 0x40, 0xc9, 0xc0, 0x5e, 0x6e, 0x8c, 0xa9, 0xa5, 0x67,
    0x60, 0x72, 0x79, 0x86, 0x63, 0x5a, 0x8b, 0xa3, 0x79, 0x5a, 0x6e, 0x90,
    0x93, 0x5c, 0x5e, 0x8a, 0x88, 0x7a, 0x7e, 0x81, 0x81, 0x82, 0x71, 0x6c,
    0x75, 0x71, 0x7c, 0x7f, 0x7b, 0x87, 0x94, 0xa7, 0xb2, 0xb4, 0x70, 0x43,
    0xb4, 0xd6, 0x75, 0x60, 0x94, 0xa9, 0x9d, 0x7c, 0x6c, 0x7a, 0x7a, 0x78,
    0x6c, 0x68, 0x7d, 0x99, 0x8a, 0x69, 0x6f, 0x82, 0x8a, 0x6a, 0x62, 0x87,
    0x88, 0x75, 0x7f, 0x94, 0x87, 0x7a, 0x6e, 0x68, 0x7e, 0x7d, 0x6f, 0x70,
    0x7f, 0x91, 0x92, 0x9a, 0xa2, 0xb0, 0x7d, 0x39, 0x96, 0xd2, 0x74, 0x60,
    0x9a, 0xa3, 0x9b, 0x7d, 0x68, 0x7f, 0x83, 0x7a, 0x6a, 0x70, 0x83, 0x99,
    0x91, 0x6d, 0x7a, 0x86, 0x86, 0x71, 0x60, 0x7b, 0x85, 0x7e, 0x80, 0x8e,
    0x89, 0x7a, 0x73, 0x72, 0x81, 0x7b, 0x6c, 0x77, 0x88, 0x92, 0x8b, 0x8e,
    0xa3, 0xba, 0x84, 0x2f, 0x83, 0xd7, 0x87, 0x60, 0x91, 0xa1, 0x9b, 0x86,
    0x6b, 0x7c, 0x84, 0x7b, 0x6f, 0x74, 0x83, 0x90, 0x92, 0x78, 0x79, 0x87,
    0x88, 0x79, 0x6b, 0x7b, 0x86, 0x84, 0x80, 0x84, 0x87, 0x7f, 0x71, 0x73,
    0x85, 0x7b, 0x70, 0x79, 0x8b, 0x9a, 0x8b, 0x85, 0xaa, 0xbe, 0x60, 0x37,
    0xb2, 0xc8, 0x69, 0x67, 0x9e, 0xa9, 0x95, 0x75, 0x6c, 0x7f, 0x87, 0x7a,
    0x63, 0x79, 0x8e, 0x8d, 0x83, 0x6f, 0x7b, 0x88, 0x81, 0x6b, 0x6c, 0x82,
    0x82, 0x74, 0x78, 0x84, 0x7d, 0x7b, 0x7b, 0x6e, 0x6e, 0x7d, 0x76, 0x67,
    0x79, 0x8f, 0x81, 0x80, 0x93, 0x99, 0xa3, 0x6c, 0x51, 0xaa, 0xa0, 0x5d,
    0x7d, 0x97, 0x8f, 0x99, 0x7b, 0x71, 0x80, 0x77, 0x7a, 0x70, 0x72, 0x87,
    0x8b, 0x7c, 0x76, 0x7d, 0x7f, 0x81, 0x6b, 0x6b, 0x7f, 0x7c, 0x77, 0x76,
    0x7e, 0x80, 0x73, 0x68, 0x74, 0x81, 0x6d, 0x6c, 0x7a, 0x85, 0x83, 0x77,
    0x8c, 0xaa, 0xa2, 0x53, 0x51, 0xb4, 0x98, 0x43, 0x60, 0x97, 0x91, 0x7c,
    0x6c, 0x73, 0x7e, 0x76, 0x6a, 0x66, 0x7d, 0x83, 0x85, 0x81, 0x74, 0x7f,
    0x85, 0x82, 0x71, 0x74, 0x87, 0x83, 0x7a, 0x7d, 0x84, 0x84, 0x7d, 0x6f,
    0x7c, 0x82, 0x66, 0x70, 0x81, 0x74, 0x75, 0x7b, 0x87, 0x89, 0x80, 0x96,
    0xaf, 0x73, 0x43, 0x93, 0xaf, 0x6c, 0x5b, 0x8c, 0xa8, 0x93, 0x77, 0x6f,
    0x7d, 0x82, 0x83, 0x6c, 0x71, 0x8e, 0x84, 0x7f, 0x74, 0x7a, 0x88, 0x84,
    0x73, 0x71, 0x87, 0x85, 0x7e, 0x79, 0x83, 0x90, 0x7f, 0x74, 0x7e, 0x78,
    0x69, 0x7e, 0x7d, 0x61, 0x7d, 0x8d, 0x78, 0x7c, 0x80, 0x89, 0x97, 0x95,
    0x9a, 0x72, 0x6a, 0xb6, 0x95, 0x56, 0x8b, 0xac, 0x92, 0x80, 0x76, 0x84,
    0x86, 0x79, 0x7c, 0x74, 0x7b, 0x85, 0x81, 0x77, 0x7a, 0x82, 0x80, 0x7e,
    0x75, 0x80, 0x8b, 0x81, 0x7c, 0x85, 0x8b, 0x81, 0x7a, 0x73, 0x7b, 0x84,
    0x74, 0x65, 0x6c, 0x83, 0x7e, 0x66, 0x6c, 0x83, 0x85, 0x7a, 0x75, 0x7b,
    0x99, 0x9d, 0x93, 0x7f, 0x64, 0xa3, 0xaf, 0x6c, 0x79, 0xa2, 0x98, 0x84,
    0x7a, 0x7c, 0x8b, 0x7f, 0x77, 0x6e, 0x73, 0x89, 0x7f, 0x7b, 0x80, 0x81,
    0x80, 0x84, 0x7f, 0x77, 0x84, 0x88, 0x85, 0x84, 0x88, 0x85, 0x7d, 0x7e,
    0x7e, 0x7a, 0x74, 0x76, 0x73, 0x6c, 0x7b, 0x7a, 0x6f, 0x75, 0x75, 0x7a,
    0x80, 0x71, 0x78, 0x8b, 0x83, 0x88, 0x8c, 0x99, 0x8b, 0x66, 0x9d, 0xab,
    0x6d, 0x73, 0x96, 0x90, 0x83, 0x7b, 0x79, 0x80, 0x79, 0x72, 0x6c, 0x75,
    0x81, 0x7c, 0x7a, 0x7b, 0x84, 0x82, 0x7a, 0x7b, 0x7d, 0x82, 0x82, 0x81,
    0x81, 0x8a, 0x88, 0x7b, 0x7c, 0x83, 0x7f, 0x71, 0x72, 0x7c, 0x7c, 0x73,
    0x6d, 0x7a, 0x7f, 0x6c, 0x6c, 0x7b, 0x79, 0x7a, 0x7a, 0x77, 0x81, 0x82,
    0x79, 0x7f, 0x8a, 0x8b, 0x8e, 0x95, 0x7e, 0x6b, 0x8f, 0x8f, 0x65, 0x70,
    0x8d, 0x85, 0x79, 0x79, 0x7b, 0x7a, 0x77, 0x77, 0x71, 0x7a, 0x81, 0x7c,
    0x81, 0x82, 0x83, 0x81, 0x82, 0x7d, 0x7c, 0x86, 0x84, 0x80, 0x85, 0x8a,
    0x86, 0x82, 0x83, 0x84, 0x81, 0x7a, 0x7d, 0x7d, 0x74, 0x72, 0x7b, 0x80,
    0x7a, 0x71, 0x76, 0x7f, 0x76, 0x75, 0x77, 0x77, 0x7e, 0x7d, 0x7b, 0x7f,
    0x81, 0x7f, 0x84, 0x84, 0x83, 0x87, 0x8e, 0x94, 0x76, 0x6a, 0x91, 0x8b,
    0x6b, 0x7b, 0x8f, 0x85, 0x7a, 0x7b, 0x87, 0x83, 0x75, 0x7b, 0x7c, 0x82,
    0x7f, 0x7c, 0x84, 0x81, 0x86, 0x82, 0x7e, 0x81, 0x80, 0x81, 0x7f, 0x83,
    0x85, 0x85, 0x82, 0x7f, 0x7f, 0x80, 0x80, 0x75, 0x76, 0x7e, 0x7b, 0x77,
    0x78, 0x7f, 0x7e, 0x77, 0x7c, 0x81, 0x7d, 0x7e, 0x7e, 0x7f, 0x84, 0x81,
    0x7d, 0x82, 0x82, 0x7b, 0x7e, 0x80, 0x81, 0x7a, 0x7b, 0x81, 0x7e, 0x7b,
    0x7b, 0x7d, 0x7e, 0x7d, 0x7c, 0x7e, 0x81, 0x80, 0x82, 0x88, 0x8b, 0x8f,
    0x82, 0x72, 0x90, 0x8e, 0x72, 0x7d, 0x8c, 0x88, 0x7c, 0x7d, 0x86, 0x81,
    0x74, 0x7a, 0x7b, 0x7c, 0x7b, 0x78, 0x83, 0x81, 0x80, 0x7e, 0x81, 0x82,
    0x7c, 0x82, 0x81, 0x81, 0x81, 0x82, 0x82, 0x81, 0x82, 0x81, 0x81, 0x7d,
    0x7f, 0x80, 0x7d, 0x7f, 0x80, 0x7f, 0x80, 0x7f, 0x80, 0x81, 0x7d, 0x80,
    0x82, 0x7f, 0x80
};
unsigned int quack_wav_len = 1467;
unsigned int p = 0;

#endif // __SOUND_H__