# リバースプロキシを使った、SSL化した複数ドメインのコンテナの構築方法

## 概要
フロントにnginx proxyのDockerイメージ（jwilder/nginx-proxy）を設置して、Webサーバー（Nginx）を構築します。

## 開発環境
- OS: Ubuntu 20.04 LTS
- Docker version 20.10.7, build 20.10.7-0ubuntu5~20.04.2
- docker-compose version 1.29.2, build 5becea4c

## Dockerイメージ
- nginx version: nginx/1.21.4
- PHP 8.0.13 (cli) (built: Nov 19 2021 21:41:50) ( NTS )
- jwilder/nginx-proxy:latest
- certbot 1.21.0

## 前提条件
- ドメインはDNSサーバーに登録済み
- SSL化のためLetsencrypt のHTTP-01 Challengeを活用する
- cronによるLetsencrypt certifications を20-30日毎に更新する
- ポート80, 443を開放していること

## 構築の手順
- 1-1 nginx-proxy(jwilder/nginx-proxy)を起動します。
- 2-1 ドメイン１(example.com）のWEBサーバーを起動します\
 ポート80のみ開放
- 2-2 certbotでSSL証明書を取得する＆所有者を一般ユーザーにする
- 3-1 nginx-proxyにドメイン１のSSL証明書をマウントする 
 - マウントポイントは/etc/nginx/certs/example.com.crt, /etc/nginx/certs/example.com.key
- 3-2 ドメイン１のWEBサーバーにポート443の設定をする
 - SSL証明書をの設定を変更し、ポート80, 443を開放する
- 3-3 ドメイン１のcertbot renewのテスト＆crontabeに登録
- 4-1 ドメイン２(sub.example.com)のWEBサーバーを起動します。 
 - ポート80のみ開放
- 2-1 - 3-2 までを繰り返す
