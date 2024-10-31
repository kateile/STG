# STG

A wrapper of _"The United Republic Of Tanzania Standard Treatment Guidelines And National Essential Medicines List For Tanzania Mainland"_ book.

Easily navigate the book with this app. No more struggling to find specific topics; quick access and a user-friendly design make reading and referencing simple and efficient.

## Screenshots

<p align="center">
    <img src="screenshots/1.png" width="30%" alt="Screenshot 1">
    &nbsp;
    <img src="screenshots/2.png" width="30%" alt="Screenshot 2">
    &nbsp;
    <img src="screenshots/3.png" width="30%" alt="Screenshot 3">
</p>

## How to Install it

1. Download APK with latest version from [here](https://github.com/kateile/STG/releases).

## Todo

- progress with percent
- most viewed
- search with recent searches
- questions and answers and bonus points
- <https://pdf.online/crop-pdf>

## Building

### Appbundle
```bash
flutter build appbundle --obfuscate --split-debug-info=./build/app/outputs/symbols 
```

### Apk

```bash
flutter build apk --obfuscate --split-debug-info=./build/app/outputs/symbols --release
```
