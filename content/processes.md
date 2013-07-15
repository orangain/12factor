## VI. プロセス
### アプリケーションを1つもしくは複数のステートレスなプロセスとして実行する

アプリケーションは、実行環境の中で1つもしくは複数の *プロセス* として実行される。

最も単純な場合では、コードは単体のスクリプトであり、実行環境は言語ランタイムがインストールされた開発者のローカルノートPCであり、プロセスはコマンドラインから実行される。（例：`python my_script.py`）スペクトラムの反対側にあるのが、[0以上の実行プロセスとしてインスタンス化される多くのプロセスタイプ](/concurrency)を使う洗練されたアプリケーションの本番デプロイである。（原文：On the other end of the spectrum, a production deploy of a sophisticated app may use many [process types, instantiated into zero or more running processes](/concurrency).）

**Twelve-Factorのプロセスはステートレスかつ[シェアードナッシング](http://en.wikipedia.org/wiki/Shared_nothing_architecture)** である。永続化する必要のあるすべてのデータはステートフルな[バックエンドサービス](/backing-services)（典型的にはデータベース）に格納しなければならない。

プロセスのメモリ空間やファイルシステムは、短時間あるいは1つのトランザクション内でのキャッシュとして利用できる。例えば、大きなファイルをダウンロードし、そのファイルを処理し、結果をデータベースに格納するという一連の処理において、ファイルシステムをキャッシュとして利用できる。Twelve-Factor Appは、メモリやディスクにキャッシュされたものが将来のリクエストやジョブにおいて利用できることを決して仮定しない -- それぞれのプロセスタイプのプロセスが多く実行されている場合、将来のリクエストやジョブが別のプロセスで処理される可能性が高い。1つのプロセスしか実行されていない場合であっても、プロセスが再起動すると、すべての局所的な状態（メモリやファイルシステムなど）が消えてしまうことがある。プロセスの再起動の要因としては、コードのデプロイ、設定の変更、プロセスを別の物理環境に移動させる実行環境などがある。

アセットパッケージャー（例：[Jammit](http://documentcloud.github.com/jammit/) や [django-assetpackager](http://code.google.com/p/django-assetpackager/)）は、ファイルシステムをコンパイルされたアセットのためのキャッシュとして利用する。Twelve-Factor Appはこのコンパイル処理を、[Rails asset pipeline](http://ryanbigg.com/guides/asset_pipeline.html)のように[ビルドステージ](/build-release-run)で行うほうが、実行時に行うよりも望ましいと考えている。

Webシステムの中には、["スティッキーセッション"](http://en.wikipedia.org/wiki/Load_balancing_%28computing%29#Persistence)に頼るものがある -- これはユーザーのセッションデータをアプリケーションプロセスのメモリにキャッシュし、同じ訪問者からの将来のリクエストが同じプロセスに送られることを期待するものである。スティッキーセッションはTwelve-Factorに違反しており、決して使ったり頼ったりしてはならない。セッション状態のデータは、有効期限を提供するデータストア（例：[Memcached](http://memcached.org/) や [Redis](http://redis.io/)）に格納するのが望ましい。