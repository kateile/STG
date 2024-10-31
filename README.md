# STG

## Screenshots

<p align="center">
<img src="screenshots/1.png" width="30%" alt="Screenshot 1">
&nbsp;
<img src="screenshots/2.png" width="30%" alt="Screenshot 1">
&nbsp;
<img src="screenshots/3.png" width="30%" alt="Screenshot 1">
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
