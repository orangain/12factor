## VII. ポートバインディング
### ポートバインディングを通してサービスを公開する

WebアプリケーションはWebサーバーコンテナの内部で実行されることがある。例えば、PHPアプリケーションは[Apache HTTPD](http://httpd.apache.org/)内部のモジュールとして実行されるだろうし、Javaアプリケーションは[Tomcat](http://tomcat.apache.org/)の内部で実行されるだろう。

**Twelve-Factor Appは完全に自己完結型** であり、Webに公開されるサービスを作成するために、コンテナが実行環境にWebサーバーのランタイムを注入することを頼りにしない。（原文：**The twelve-factor app is completely self-contained** and does not rely on runtime injection of a webserver into the execution environment to create a web-facing service.）Webアプリケーションは **HTTPをポートにバインドすることでサービスとして公開し、** そのポートにリクエストが来るのを待つ。

ローカルの開発環境では、開発者はアプリケーションによって公開されたサービスにアクセスするために、`http://localhost:5000/`のようなサービスのURLにアクセスする。本番環境では、ルーティング層が外部に公開しているホスト名からポートにバインドされたWebプロセスへとリクエストをルーティングする。

これは一般に、[依存関係宣言](/dependencies)を使ってWebサーバーライブラリをアプリケーションに追加することで実装される。Webサーバーライブラリの例として、Pythonにおける[Tornado](http://www.tornadoweb.org/)、Rubyにおける[Thin](http://code.macournoyer.com/thin/)、Javaやその他のJVMベースの言語における[Jetty](http://jetty.codehaus.org/jetty/)などがある。これは *ユーザー空間* すなわちアプリケーションのコード内で完結する。リクエストを処理するための実行環境との契約は、ポートをバインドすることである。

ポートバインディングによって公開されるサービスはHTTPだけではない。ほぼすべてのサーバーソフトウェアは、ポートをバインドしてリクエストを待つプロセスを用いて動作する。例として、[ejabberd](http://www.ejabberd.im/)（[XMPP](http://xmpp.org/)を話す）や [Redis](http://redis.io/)（[Redisプロトコル](http://redis.io/topics/protocol)を話す）などがある。

ここで注目すべきは、ポートバインディングの方法によって、あるアプリケーションが他のアプリケーションにとっての[バックエンドサービス](/backing-services)になれる点である。バックエンドアプリケーションへのURLを提供し、利用するアプリケーションの[設定](/config)にリソースハンドルとして格納すればよい。